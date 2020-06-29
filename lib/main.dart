import 'package:flutter/material.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:passkey/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: PasswordProvider()),
        ],
        child: MaterialApp(
            title: 'passkey',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomePage(),
            debugShowCheckedModeBanner: false));
  }
}
