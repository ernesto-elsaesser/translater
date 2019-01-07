import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'WordsWidget.dart';
import 'SelectionHeader.dart';
import 'SplitBox.dart';

class VocabularyWidget extends StatefulWidget {
  @override
  VocabularyWidgetState createState() => new VocabularyWidgetState();
}

class VocabularyWidgetState extends State<VocabularyWidget> {

  Language _selectedLanguage = Language.english;
  Word _selectedWord;

  @override
  Widget build(BuildContext context) {

    final languageSwitcher = SplitBox(
      _buildLangaugeButton(Language.english),
      _buildLangaugeButton(Language.german)
    );

    List<Widget> sections = [languageSwitcher];

    if (_selectedWord != null) {
      final selectionHeader = SelectionHeader(_selectedWord,
        onDismiss: _unselect);
      sections.add(selectionHeader);
    }
    final wordList = Flexible(child: _buildWordList());
    sections.add(wordList);
    return Column(children: sections);
  }

  WordsWidget _buildWordList() {
    final vocabulary = VocabularyService.instance;
    Iterable<WordItem> items;
    if (_selectedWord != null) {
      final translations = vocabulary.translationsFor(_selectedWord);
      items = translations.map((t) => WordsWidget.translatedItem(_selectedWord, t, _update));
    } else {
      final learnedWords = vocabulary.learnedWords(_selectedLanguage);
      items = learnedWords.map((w) => WordsWidget.translatableItem(w, _select));
    }
    return WordsWidget(items.toList(), emptyText: "No entries.");
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

  void _select(Word word) {
    setState(() {
      _selectedWord = word;
    });
  }

  void _unselect() {
    setState(() {
      _selectedWord = null;
    });
  }

  void _update(Word word) {
    final translations = VocabularyService.instance.translationsFor(_selectedWord);
    if (translations.isEmpty) {
      setState(() {
        _selectedWord = null;
      });
    } else {
      setState(() {});
    }
  }
}