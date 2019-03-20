import 'package:flutter/cupertino.dart';
import 'dart:math';

import '../services/ConfigurationService.dart';
import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'LanguageSwitcher.dart';
import 'WordTest.dart';

class RetentionMetric extends StatefulWidget {
  @override
  RetentionMetricState createState() => RetentionMetricState();
}

class RetentionMetricState extends State<RetentionMetric> {

  Language _selectedLanguage = ConfigurationService.targetLanguage;

  @override
  Widget build(BuildContext context) {

    final languageSwitcher = LanguageSwitcher(
        selected: _selectedLanguage,
        onSwitch: _switchLanguage
    );

    List<Widget> sections = [
      SizedBox(height: 50),
      Text("Measure Retention:"),
      SizedBox(height: 40),
      _buildButton("SHORT TEST", () => _shortTest(context)),
      SizedBox(height: 20),
      _buildButton("FULL TEST", () => _fullTest(context)),
      SizedBox(height: 50),
      Text("Source Language:"),
      SizedBox(height: 20),
      Container(padding: EdgeInsets.symmetric(horizontal: 30) , child: languageSwitcher),
    ];
    return SectionedTab(sections);
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    final textStyle = TextStyle(color: CupertinoColors.white);
    return Center(child: CupertinoButton(
      color: Color(0xFF8080C0),
      child: SizedBox(
        width: 150, 
        child: Center(child: Text(text, style: textStyle))),
      onPressed: onPressed)
    );
  }

  void _switchLanguage(Language language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _shortTest(BuildContext context) {
    var relations = VocabularyService.instance.knownRelations(_selectedLanguage);
    relations.shuffle(Random());
    relations = relations.sublist(0,5);
    _startTest(context, relations);
  }

  void _fullTest(BuildContext context) {
    final relations = VocabularyService.instance.knownRelations(_selectedLanguage);
    _startTest(context, relations);
  }

  void _startTest(BuildContext context, List<WordRelation> relations) {
    final route = CupertinoPageRoute(
      title: "Retention Test", 
      builder: (_) => WordTest(relations));
    Navigator.push(context, route);
  }
}