import 'dart:io';

import 'package:encrypt/encrypt.dart' as decrypt;
import 'package:flutter/material.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:passkey/screens/list.dart';
import 'package:provider/provider.dart';

class DecryptPage extends StatefulWidget {
  final String filePath;

  DecryptPage(this.filePath);

  @override
  _DecryptPageState createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  TextEditingController filePathController;
  TextEditingController passkeyController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    filePathController = TextEditingController(text: widget.filePath);
    passkeyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    final pwdProvider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            "Open File",
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
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    labelText: "File Path",
                    labelStyle: TextStyle(fontFamily: "Subtitle"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
                controller: filePathController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autofocus: true,
                obscureText: _obscureText,
                maxLength: 32,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.lock : Icons.lock_open),
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
                    "Decrypt",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: "Title"),
                  ),
                  onPressed: () async {
                    String passkey = passkeyController.text;

                    try {
                      final file = File(widget.filePath);
                      String contents = file.readAsStringSync();
                      final encrypted = decrypt.Encrypted.fromBase64(contents);
                      final key = decrypt.Key.fromUtf8(passkey.padRight(32));
                      final decrypter = decrypt.Encrypter(decrypt.AES(key));
                      final decrypted = decrypter.decrypt(encrypted,
                          iv: decrypt.IV.fromLength(16));
                      pwdProvider.loadPasswords(decrypted);

                      // save file name, path and passkey in memory
                      final fileName = widget.filePath.split('/').last;
                      pwdProvider.setFileName(fileName);
                      pwdProvider.setFilePath(widget.filePath);
                      pwdProvider.passkey = passkey;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ListPage()));
                    } on FileSystemException catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "File doesn't exist!",
                                style: TextStyle(
                                    fontFamily: "Title", color: primaryColor),
                              ),
                              content: Text(
                                "File: ${widget.filePath}",
                                style: TextStyle(fontFamily: "Subtitle"),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Dismiss"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Wrong PassKey!",
                                style: TextStyle(
                                    fontFamily: "Title", color: primaryColor),
                              ),
                              content: Text(
                                "PassKey: $passkey",
                                style: TextStyle(fontFamily: "Subtitle"),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Dismiss"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
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
