import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:passkey/screens/list.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class EncryptPage extends StatefulWidget {
  final bool newFile;

  EncryptPage(this.newFile);

  @override
  _EncryptPageState createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController passkeyController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    final pwdProvider = Provider.of<PasswordProvider>(context);
    final passwords = pwdProvider.getPasswords();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            widget.newFile ? "Create File" : "Save As",
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
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      return value.isEmpty ? 'File name is required.' : null;
                    },
                    decoration: InputDecoration(
                        labelText: "File Name",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        suffixText: ".safe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                    controller: fileNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: _obscureText,
                    maxLength: 32,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon:
                              Icon(_obscureText ? Icons.lock : Icons.lock_open),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: "PassKey",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                    controller: passkeyController,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MaterialButton(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Title"),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final FileChooserResult result = await showSavePanel(
                            suggestedFileName:
                                path.basename(fileNameController.text),
                            allowedFileTypes: [
                              FileTypeFilterGroup(
                                  label: 'passkey', fileExtensions: ['safe'])
                            ],
                            confirmButtonText: 'Confirm',
                          );
                          if (!result.canceled) {
                            // encrypt & write to file
                            final file = File(result.paths.first);
                            final key = encrypt.Key.fromUtf8(
                                passkeyController.text.padRight(32));
                            final encrypter =
                                encrypt.Encrypter(encrypt.AES(key));
                            final encrypted = encrypter.encrypt(
                                jsonEncode(widget.newFile ? [] : passwords),
                                iv: encrypt.IV.fromLength(16));
                            file.writeAsString(encrypted.base64);

                            // save file name, path and passkey in memory
                            final fileName = result.paths.first.split('/').last;
                            final passkey = passkeyController.text;
                            if (widget.newFile) {
                              fileNameController.text =
                                  fileName.substring(0, fileName.length - 5);
                              pwdProvider.setFileName(fileName);
                              pwdProvider.filePath = result.paths.first;
                              pwdProvider.passkey = passkey;
                              pwdProvider.loadPasswords('[]');
                            }

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "File Created Successfully!",
                                      style: TextStyle(
                                          fontFamily: "Title",
                                          color: primaryColor),
                                    ),
                                    content: Text(
                                      "File Name: $fileName \n\nPasskey: $passkey",
                                      style: TextStyle(fontFamily: "Subtitle"),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Cool"),
                                        onPressed: () {
                                          if (widget.newFile) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ListPage()));
                                          } else {
                                            var count = 0;
                                            Navigator.popUntil(context,
                                                (route) {
                                              return count++ == 2;
                                            });
                                          }
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      color: primaryColor,
                      minWidth: size.width * 0.8,
                      height: 48,
                    )),
              ])),
        ],
      )),
    );
  }
}
