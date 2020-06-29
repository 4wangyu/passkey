import 'package:flutter/material.dart';
import 'package:passkey/model/password_model.dart';

class PasswordProvider with ChangeNotifier {
  Map<String, Password> _passwordMap = new Map();

  List<Password> getPasswords() {
    List<Password> pwdList = _passwordMap.values.toList();
    pwdList.sort((a, b) => a.title.compareTo(b.title));
    return pwdList;
  }

  void addPassword(Password pwd) {
    _passwordMap[pwd.id] = pwd;
    notifyListeners();
  }

  void updatePassword(Password pwd) {
    if (_passwordMap.containsKey(pwd.id)) {
      _passwordMap.update(pwd.id, (value) => pwd);
      notifyListeners();
    }
  }

  void deletePassword(Password pwd) {
    _passwordMap.remove(pwd.id);
    notifyListeners();
  }
}
