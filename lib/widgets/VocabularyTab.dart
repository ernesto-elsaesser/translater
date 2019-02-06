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
    final relations = vocabulary.knownRelations(_selectedLanguage);
    final items = relations.map(_makeItem).toList();
    return WordList(items, emptyText: "No entries.");
  }

  AddableItem _makeItem(WordRelation relation) {
    VoidCallback onTap = () {
      VocabularyService.instance.unlearn(relation);
      setState(() {});
    };
    return AddableItem(
      text: "${relation.word.text} - ${relation.translation.text}", 
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