import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'WordList.dart';
import 'SplitBox.dart';

class VocabularyTab extends StatefulWidget {
  @override
  VocabularyTabState createState() => new VocabularyTabState();
}

class VocabularyTabState extends State<VocabularyTab> {

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

    return SectionedTab(sections);
  }

  WordList _buildWordList() {
    final vocabulary = VocabularyService.instance;
    final translatedWords = vocabulary.knownTranslations(_selectedLanguage);
    final items = translatedWords.expand( (tw) {
      return tw.translations.map( (t) => _makeItem(tw.word, t) );
    }).toList();
    return WordList(items, emptyText: "No entries.");
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