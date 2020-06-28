import 'package:flutter/material.dart';
import 'package:passkey/model/password_model.dart';
import 'package:passkey/screens/password.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Password> passwords = List<Password>(0);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: primaryColor),
        automaticallyImplyLeading: false,
        title: Text(
          "Passwords",
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
                  Navigator.of(context).pop();
                },
              ),
              PopupMenuItem(
                child: Text('Open...'),
                value: () {
                  Navigator.of(context).pop();
                },
              ),
              PopupMenuItem(
                child: Text('Save'),
                value: () {},
              ),
              PopupMenuItem(
                child: Text('Save As...'),
                value: () {},
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
                            var item = password;
                            //To delete
                            setState(() {
                              passwords.removeAt(index);
                            });
                            //To show a snackbar with the UNDO button
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Password deleted"),
                                action: SnackBarAction(
                                    label: "UNDO",
                                    onPressed: () {
                                      setState(() {
                                        passwords.insert(index, item);
                                      });
                                    })));
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PasswordPage()));
                            },
                            child: ListTile(
                                title: Text(
                                  password.title,
                                  style: TextStyle(
                                    fontFamily: 'Title',
                                  ),
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
                  builder: (BuildContext context) => PasswordPage()));
        },
      ),
    );
  }
}
