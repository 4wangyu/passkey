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
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Passwords",
                  style: TextStyle(
                      fontFamily: "Title", fontSize: 24, color: primaryColor),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: primaryColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            )),
          ),
          Expanded(
              child: passwords.isEmpty
                  ? Center(
                      child: Text(
                        "No Passwords. \nClick '+' button to add a password.",
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
