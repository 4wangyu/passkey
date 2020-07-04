import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:passkey/provider/password_provider.dart';
import 'package:passkey/screens/decrypt.dart';
import 'package:passkey/screens/encrypt.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color primaryColor = Theme.of(context).primaryColor;
    final pwdProvider = Provider.of<PasswordProvider>(context);
    final historyList = pwdProvider.historyList;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'PassKey',
            style: TextStyle(
              fontFamily: "Title",
              fontSize: 28,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 30,
                  runSpacing: 20,
                  children: <Widget>[
                    getActionIcon(
                      context,
                      theme,
                      primaryColor,
                      Icons.insert_drive_file,
                      'Open File',
                      () async {
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
                    getActionIcon(
                        context, theme, primaryColor, Icons.add, 'New File',
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EncryptPage(true)));
                    }),
                  ],
                ),
                const SizedBox(height: 40),
                IntrinsicWidth(
                  stepWidth: 100,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Recent:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        ...ListTile.divideTiles(
                            context: context,
                            tiles: historyList.isNotEmpty
                                ? historyList.map((history) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    DecryptPage(history.path)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    history.path,
                                                    style: TextStyle(
                                                        color: primaryColor),
                                                  ),
                                                  // Text(
                                                  //   history.date.toString(),
                                                  //   overflow:
                                                  //       TextOverflow.ellipsis,
                                                  //   maxLines: 1,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                : [
                                    const Text('No files have been opened yet.')
                                  ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget getActionIcon(BuildContext context, ThemeData theme, Color primaryColor,
    IconData icon, String label, Function onTap) {
  return SizedBox(
    width: 120,
    height: 96,
    child: Material(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      color: primaryColor,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.bodyText2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  strutStyle: const StrutStyle(leading: 0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
