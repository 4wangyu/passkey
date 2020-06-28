import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: primaryColor),
            title: Text(
              "Passwords",
              style: TextStyle(
                  fontFamily: "Title", fontSize: 28, color: primaryColor),
              overflow: TextOverflow.ellipsis,
            )));
  }
}
