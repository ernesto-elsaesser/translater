import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'WordsWidget.dart';
import 'SplitBox.dart';

class VocabularyWidget extends StatefulWidget {
  @override
  VocabularyWidgetState createState() => new VocabularyWidgetState();
}

class VocabularyWidgetState extends State<VocabularyWidget> {

  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {

    final languageSwitcher = SplitBox(
      _buildLangaugeButton(Language.english),
      _buildLangaugeButton(Language.german)
    );
    List<Widget> sections = [languageSwitcher];

    final wordList = Flexible(child: _buildWordList());
    sections.add(wordList);

    return Column(children: sections);
  }

  WordsWidget _buildWordList() {
    final vocabulary = VocabularyService.instance;
    final learnedWords = vocabulary.learnedWords(_selectedLanguage);
    final items = learnedWords.entries.expand( (e) {
      final word = Word(e.key, _selectedLanguage);
      return e.value.map( (t) => _makeItem(word, t) );
    }).toList();
    return WordsWidget(items, emptyText: "No entries.");
  }

  AddableItem _makeItem(Word word, Word translation) {
    VoidCallback onTap = () {
      VocabularyService.instance.unlearn(word, translation);
      setState(() {});
    };
    return AddableItem(
      text: "${word.text} - ${translation.text}", 
      isAdded: () => true, 
      onTap: onTap);
  }

  CupertinoButton _buildLangaugeButton(Language language) {
    final isSelected = _selectedLanguage == language;
    final color = isSelected ? Color(0xFFBBBBDD) : CupertinoColors.white;
    final textStyle = TextStyle(color: CupertinoColors.black);
    return CupertinoButton(
      child: Text(language.code.toUpperCase(), style: textStyle),
      color: color,
      onPressed: () => _switchLanguage(language));
  }

  void _switchLanguage(Language language) {
    setState(() {
      _selectedLanguage = language;
    });
  }
}