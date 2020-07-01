import 'dart:math';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:passkey/screens/decrypt.dart';
import 'package:passkey/screens/list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Size size = MediaQuery.of(context).size;
    double iconSize = max(size.width * 0.1, 24);

    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.insert_drive_file),
                      color: primaryColor,
                      iconSize: iconSize,
                      onPressed: () async {
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
                      }),
                  Text(
                    'Open File',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    color: primaryColor,
                    iconSize: iconSize,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ListPage()));
                    },
                  ),
                  Text(
                    'New File',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        ]))));
  }
}
