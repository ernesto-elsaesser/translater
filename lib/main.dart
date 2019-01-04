import 'package:flutter/cupertino.dart';

import 'widgets/SearchWidget.dart';

void main() => runApp(TranslaterApp());

class TranslaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 21.0);
    return CupertinoApp(
      title: 'Translater',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Translater', 
            style: titleStyle)
          ),
        child: SafeArea(
          top: true, 
          bottom: false, 
          child: SearchWidget()
        )
      )
    );
  }
}
