import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final pwdForm = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController teleController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(new ClipboardData(text: passwordController.text));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied to Clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            "Add Password",
            style: TextStyle(
                fontFamily: "Title", fontSize: 28, color: primaryColor),
            overflow: TextOverflow.ellipsis,
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: pwdForm,
              child: Column(
                children: <Widget>[
                  pwdFormField("Title", titleController, validator: (value) {
                    return value.isEmpty ? 'Please enter title' : null;
                  }),
                  pwdFormField("Username", usernameController),
                  pwdFormField("Email", emailController),
                  pwdFormField("Password", passwordController),
                  pwdFormField("Pin", pinController),
                  pwdFormField("Telephone", teleController),
                  pwdFormField("Remarks", remarkController),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: MaterialButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Title"),
                        ),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        color: primaryColor,
                        minWidth: size.width * 0.8,
                        height: 48,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget pwdFormField(String label, TextEditingController controller,
    {Function validator, bool obscureText = false}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextFormField(
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: "Subtitle"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
      controller: controller,
    ),
  );
}
