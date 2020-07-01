import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:passkey/model/password_model.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:passkey/screens/decrypt.dart';
import 'package:passkey/screens/encrypt.dart';
import 'package:passkey/screens/password.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    final pwdProvider = Provider.of<PasswordProvider>(context);
    final passwords = pwdProvider.getPasswords();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: primaryColor),
        automaticallyImplyLeading: false,
        title: Text(
          pwdProvider.getFileName() ?? 'Passwords',
          style:
              TextStyle(fontFamily: "Title", fontSize: 28, color: primaryColor),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            onSelected: (func) {
              func();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('New File'),
                value: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EncryptPage(true)));
                },
              ),
              PopupMenuItem(
                child: Text('Open...'),
                value: () async {
                  final FileChooserResult result = await showOpenPanel(
                    allowedFileTypes: [
                      FileTypeFilterGroup(
                          label: 'passkey', fileExtensions: ['safe'])
                    ],
                  );
                  if (!result.canceled) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DecryptPage(result.paths.first)));
                  }
                },
              ),
              PopupMenuItem(
                child: Text('Save As...'),
                value: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EncryptPage(false)));
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: passwords.isEmpty
                  ? Center(
                      child: Text(
                        "No passwords. \nClick '+' button to add a password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: passwords.length,
                      itemBuilder: (BuildContext context, int index) {
                        Password password = passwords[index];
                        return Dismissible(
                          key: ObjectKey(password.id),
                          onDismissed: (direction) {
                            final cachedPwd = password;
                            pwdProvider.deletePassword(password);
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Password deleted"),
                                action: SnackBarAction(
                                    label: "UNDO",
                                    onPressed: () {
                                      pwdProvider.addPassword(cachedPwd);
                                    })));
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PasswordPage(password)));
                            },
                            child: ListTile(
                                title: Text(
                                  password.title,
                                  style: TextStyle(
                                      fontFamily: 'Title',
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  password.username ?? password.email,
                                  style: TextStyle(
                                    fontFamily: 'Subtitle',
                                  ),
                                )),
                          ),
                        );
                      },
                    )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PasswordPage(null)));
        },
      ),
    );
  }
}
