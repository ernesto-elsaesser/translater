import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'WordList.dart';
import 'LanguageSwitcher.dart';

class VocabularyTab extends StatefulWidget {
  @override
  VocabularyTabState createState() => VocabularyTabState();
}

class VocabularyTabState extends State<VocabularyTab> {

  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {

    final languageSwitcher = LanguageSwitcher(
      Language.english, Language.german,
      selected: _selectedLanguage,
      onSwitch: _switchLanguage
    );
    List<Widget> sections = [languageSwitcher];

    final wordList = Flexible(child: _buildWordList());
    sections.add(wordList);

    return SectionedTab(sections);
  }

  WordList _buildWordList() {
    final relations = VocabularyService.instance.knownRelations(_selectedLanguage);
    relations.sort();
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

  void _switchLanguage(Language language) {
    setState(() {
      _selectedLanguage = language;
    });
  }
}