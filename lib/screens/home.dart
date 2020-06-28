import 'package:flutter/material.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
                    iconSize: iconSize,
                    onPressed: () {
                      setState(() {});
                    },
                  ),
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
                    iconSize: iconSize,
                    onPressed: () {
                      setState(() {});
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
