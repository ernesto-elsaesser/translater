import 'package:flutter/cupertino.dart';

import '../model/VocabularyModel.dart';

class SelectionHeader extends StatelessWidget {
  const SelectionHeader(this.word, {Key key, this.onDismiss}) : super(key: key);

  final Word word;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final text = "${word.language.code.toUpperCase()}: ${word.text}";
    return Container(
          color: Color(0xFFBBBBDD),
          child: Row(children: <Widget>[
            SizedBox(width: 60),
            Expanded(child: Text(text, textAlign: TextAlign.center)),
            CupertinoButton(
              child: Icon(CupertinoIcons.clear_thick),
              onPressed: onDismiss)
          ]));
  }
}