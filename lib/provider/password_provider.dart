import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:passkey/model/history_model.dart';
import 'package:passkey/model/password_model.dart';
import 'package:passkey/provider/history_database.dart';

class PasswordProvider with ChangeNotifier {
  Map<String, Password> _passwordMap = new Map();
  HistoryDatabase _historyDatabase = HistoryDatabase();
  List<History> historyList = [];
  String _fileName;
  String _filePath;
  String passkey;

  PasswordProvider() {
    loadHistoryList();
  }

  void loadHistoryList() {
    _historyDatabase.getRecentHistory().then((hl) {
      historyList = hl;
      notifyListeners();
    });
  }

  String getFilePath() {
    return _filePath;
  }

  void setFilePath(String fp) {
    _filePath = fp;
    _historyDatabase
        .saveHistory(History(fp, DateTime.now().millisecondsSinceEpoch));
    loadHistoryList();
  }

  String getFileName() {
    return _fileName;
  }

  void setFileName(String fn) {
    _fileName = fn;
    notifyListeners();
  }

  void loadPasswords(String pwdsStr) {
    _passwordMap = new Map();
    List<dynamic> pwds = jsonDecode(pwdsStr);
    pwds.forEach((p) {
      final pwd = Password.fromJson(p);
      _passwordMap[pwd.id] = pwd;
    });
    notifyListeners();
  }

  List<Password> getPasswords() {
    List<Password> pwdList = _passwordMap.values.toList();
    pwdList.sort((a, b) => a.title.compareTo(b.title));
    return pwdList;
  }

  void addPassword(Password pwd) {
    _passwordMap[pwd.id] = pwd;
    notifyListeners();
    _updateFile();
  }

  void updatePassword(Password pwd) {
    if (_passwordMap.containsKey(pwd.id)) {
      _passwordMap.update(pwd.id, (value) => pwd);
      notifyListeners();
      _updateFile();
    }
  }

  void deletePassword(Password pwd) {
    _passwordMap.remove(pwd.id);
    notifyListeners();
    _updateFile();
  }

  void _updateFile() {
    final file = File(getFilePath());
    final key = encrypt.Key.fromUtf8(passkey.padRight(32));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonEncode(getPasswords()),
        iv: encrypt.IV.fromLength(16));
    file.writeAsString(encrypted.base64);
  }
}
