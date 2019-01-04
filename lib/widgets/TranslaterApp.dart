import 'package:flutter/cupertino.dart';

import '../widgets/SearchWidget.dart';
import '../services/VocabularyService.dart';

class TranslaterApp extends StatefulWidget {
  @override
  TranslaterAppState createState() => new TranslaterAppState();
}

class TranslaterAppState extends State<TranslaterApp> {
  @override
  void initState() {
    super.initState();
    VocabularyService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 21.0);
    return CupertinoApp(
        title: 'Translater',
        home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: Text('Translater', style: titleStyle)),
            child: SafeArea(top: true, bottom: false, child: SearchWidget())));
  }
}
