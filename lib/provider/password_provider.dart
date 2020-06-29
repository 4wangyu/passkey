import 'package:flutter/material.dart';
import 'package:passkey/model/password_model.dart';

class PasswordProvider with ChangeNotifier {
  Map<String, Password> _passwordMap = new Map();

  List<Password> getPasswords() {
    return _passwordMap.values.toList();
  }

  void addPassword(Password pwd) {
    _passwordMap[pwd.id] = pwd;
    notifyListeners();
  }

  void updatePassword(Password pwd) {}

  void deletePassword(Password pwd) {
    _passwordMap.remove(pwd.id);
    notifyListeners();
  }
}
