import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passkey/model/password_model.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PasswordPage extends StatefulWidget {
  final Password password;

  PasswordPage(this.password);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleController;
  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController pinController;
  TextEditingController teleController;
  TextEditingController remarkController;

  bool get _isUpdate {
    return widget.password != null;
  }

  @override
  void initState() {
    super.initState();
    _initControllers(widget.password);
  }

  void _initControllers(Password pwd) {
    titleController = TextEditingController(text: pwd?.title);
    usernameController = TextEditingController(text: pwd?.username);
    emailController = TextEditingController(text: pwd?.email);
    passwordController = TextEditingController(text: pwd?.password);
    pinController = TextEditingController(text: pwd?.pin);
    teleController = TextEditingController(text: pwd?.tele);
    remarkController = TextEditingController(text: pwd?.remark);
  }

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(new ClipboardData(text: passwordController.text));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied to Clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Password getPassword() {
    return Password(
        id: _isUpdate ? widget.password.id : Uuid().v4(),
        title: titleController.text,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        pin: pinController.text,
        tele: teleController.text,
        remark: remarkController.text);
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;

    final pwdProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            "${_isUpdate ? 'Edit' : 'Add'} Password",
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
              key: _formKey,
              child: Column(
                children: <Widget>[
                  pwdFormField("Title", titleController, validator: (value) {
                    return value.isEmpty ? 'Title is required.' : null;
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
                          "${_isUpdate ? 'Update' : 'Save'}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Title"),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_isUpdate) {
                              pwdProvider.updatePassword(getPassword());
                            } else {
                              pwdProvider.addPassword(getPassword());
                            }
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Password ${titleController.text} ${_isUpdate ? 'updated' : 'added'}!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            if (!_isUpdate) {
                              _formKey.currentState.reset();
                            }
                          }
                        },
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
