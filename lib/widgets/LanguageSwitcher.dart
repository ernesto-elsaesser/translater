import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/ConfigurationService.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher(
    {@required this.selected,
    @required this.onSwitch});

  final Language selected;
  final Function(Language) onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Row(children: <Widget>[
          _buildLangaugeButton(ConfigurationService.sourceLanguage),
          SizedBox(width: 10.0),
          _buildLangaugeButton(ConfigurationService.targetLanguage)
        ]));
  }

  Widget _buildLangaugeButton(Language language) {
    VoidCallback onPressed;
    if (selected != language) {
      onPressed = () => onSwitch(language);
    }
    return Expanded(child: OutlineButton(
      child: Text(shortcode(language, upper: true)),
      disabledBorderColor: CupertinoColors.inactiveGray,
      disabledTextColor: CupertinoColors.black,
      splashColor: CupertinoColors.white,
      onPressed: onPressed));
  }
}