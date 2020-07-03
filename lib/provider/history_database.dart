import 'dart:io';
import 'dart:math';
import 'package:passkey/model/history_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDatabase {
  Database _db;
  final String _historyTable = "history";
  final String _filepath = "path";
  final String _accessDate = "date";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    Directory appDir = await _getAppDir();
    final path = join(appDir.path, ".history.db");
    var db = openDatabase(path, onCreate: _onCreate, version: 1);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_historyTable ($_filepath TEXT PRIMARY KEY, $_accessDate INTEGER)");
  }

  Future<int> saveHistory(History history) async {
    Database dbClient = await db;
    History h = await _getHistory(history.path);
    if (h != null) {
      int res = await dbClient.update("$_historyTable", history.toMap(),
          where: "path = ?", whereArgs: [history.path]);
      return res;
    } else {
      int res = await dbClient.insert(_historyTable, history.toMap());
      return res;
    }
  }

  Future<History> _getHistory(String path) async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery("SELECT * FROM $_historyTable WHERE path = $path");
    if (res.length > 0) {
      return History.fromMap(res.first);
    }
    return null;
  }

  Future<List<History>> getRecentHistory() async {
    var dbClient = await db;
    List allItems = await dbClient.query("$_historyTable");
    print(allItems);
    List<History> allHistory =
        allItems.map((el) => History.fromObj(el)).toList();
    allHistory.sort((b, a) => a.date.compareTo(b.date)); // descending
    // only store 5 latest file paths
    if (allHistory.length > 5) {
      for (var i = 5; i < allHistory.length; i++) {
        _deleteHistory(allHistory[i]);
      }
    }
    return allHistory.take(5).toList();
  }

  Future<int> _deleteHistory(History history) async {
    var dbClient = await db;
    int res = await dbClient
        .delete("$_historyTable", where: "path = ?", whereArgs: [history.path]);
    return res;
  }

  Future<Directory> _getAppDir() {
    if (Platform.isIOS || Platform.isMacOS) {
      return getApplicationSupportDirectory();
    }
    if (Platform.isAndroid) {
      return getApplicationDocumentsDirectory();
    }
    return _getUserHomeDirectory();
  }

  Future<Directory> _getUserHomeDirectory() async {
    final userHome =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final dataDir = Directory(join(userHome, '.passkey'));
    await dataDir.create(recursive: true);
    return dataDir;
  }
}
