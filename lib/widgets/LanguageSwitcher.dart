import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/VocabularyModel.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher(
    this.left, 
    this.right, 
    {@required this.selected, 
    @required this.onSwitch});

  final Language left, right, selected;
  final Function(Language) onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          _buildLangaugeButton(left),
          SizedBox(width: 10.0),
          _buildLangaugeButton(right)
        ]));
  }

  Widget _buildLangaugeButton(Language language) {
    VoidCallback onPressed;
    if (selected != language) {
      onPressed = () => onSwitch(language);
    }
    return Expanded(child: OutlineButton(
      child: Text(language.code.toUpperCase()),
      disabledBorderColor: CupertinoColors.inactiveGray,
      disabledTextColor: CupertinoColors.black,
      splashColor: CupertinoColors.white,
      onPressed: onPressed));
  }
}