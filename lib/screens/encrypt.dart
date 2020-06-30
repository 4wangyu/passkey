import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptPage extends StatefulWidget {
  @override
  _EncryptPageState createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController masterPassController = TextEditingController();
  TextEditingController filePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    final pwdProvider = Provider.of<PasswordProvider>(context);
    final passwords = pwdProvider.getPasswords();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            "Create File",
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
                    validator: (value) {
                      return value.isEmpty ? 'File name is required.' : null;
                    },
                    decoration: InputDecoration(
                        labelText: "File Name",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        suffixText: ".safe",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                    controller: filePathController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: true,
                    maxLength: 32,
                    decoration: InputDecoration(
                        labelText: "Master Passord",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                    controller: masterPassController,
                  ),
                ),
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final FileChooserResult result = await showSavePanel(
                            suggestedFileName:
                                path.basename(filePathController.text),
                            allowedFileTypes: [
                              FileTypeFilterGroup(
                                  label: 'passkey', fileExtensions: ['safe'])
                            ],
                            confirmButtonText: 'Confirm',
                          );
                          if (!result.canceled) {
                            final file = File(result.paths.first);
                            final key = encrypt.Key.fromUtf8(
                                masterPassController.text.padRight(32));
                            final encrypter =
                                encrypt.Encrypter(encrypt.AES(key));
                            final encrypted = encrypter.encrypt(
                                jsonEncode(passwords),
                                iv: encrypt.IV.fromLength(16));
                            file.writeAsString(encrypted.base64);
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
