import 'package:flutter/cupertino.dart';
import 'dart:math';

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'LanguageSwitcher.dart';
import 'WordTest.dart';

class RetentionMetric extends StatefulWidget {
  @override
  RetentionMetricState createState() => RetentionMetricState();
}

class RetentionMetricState extends State<RetentionMetric> {

  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {

    final languageSwitcher = LanguageSwitcher(
        Language.english, Language.german, 
        selected: _selectedLanguage,
        onSwitch: _switchLanguage
    );

    List<Widget> sections = [
      SizedBox(height: 50),
      Text("Measure Retention:"),
      SizedBox(height: 50),
      Center(child: CupertinoButton.filled(
        child: Text("Test 5 random words"),
        onPressed: () => _shortTest(context))
      ),
      SizedBox(height: 20),
      Center(child: CupertinoButton.filled(
        child: Text("Test all words"),
        onPressed: () => _fullTest(context))
      ),
      SizedBox(height: 50),
      Text("Source Language"),
      SizedBox(height: 10),
      languageSwitcher,
    ];
    return SectionedTab(sections);
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