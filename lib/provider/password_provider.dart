import 'package:flutter/material.dart';
import 'package:passkey/model/password_model.dart';

class PasswordProvider with ChangeNotifier {
  List<Password> passwords = [];

  addPassword(Password pwd) {
    passwords.add(pwd);
    notifyListeners();
  }
}
