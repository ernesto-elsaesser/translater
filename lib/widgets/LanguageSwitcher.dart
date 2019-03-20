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
          _buildLangaugeButton(ConfigurationService.targetLanguage),
          SizedBox(width: 10.0),
          _buildLangaugeButton(ConfigurationService.sourceLanguage)
        ]));
  }

  Widget _buildLangaugeButton(Language language) {
    final borderSide = BorderSide(width: 2.0, color: CupertinoColors.lightBackgroundGray);
    VoidCallback onPressed;
    if (selected != language) {
      onPressed = () => onSwitch(language);
    }
    return Expanded(child: OutlineButton(
      child: Text(shortcode(language, upper: true)),
      disabledBorderColor: Color(0xFF6060A0),
      disabledTextColor: CupertinoColors.black,
      splashColor: CupertinoColors.white,
      borderSide: borderSide,
      onPressed: onPressed));
  }
}