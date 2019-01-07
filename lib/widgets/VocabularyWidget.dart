import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'WordsWidget.dart';

class VocabularyWidget extends StatefulWidget {
  @override
  VocabularyWidgetState createState() => new VocabularyWidgetState();
}

class VocabularyWidgetState extends State<VocabularyWidget> {

  Language _selectedLanguage = Language.english;
  Word _selectedWord;

  @override
  Widget build(BuildContext context) {
    List<WordItem> items;
    if (_selectedWord != null) {
      items = _knownTranslations(_selectedWord);
    } else {
      items = _knownWords();
    }
    return WordsWidget(items, emptyText: "No entries.");
  }

  List<WordItem> _knownWords() {
    final learnedWords = VocabularyService.instance.learnedWords(_selectedLanguage);
    return learnedWords.map((w) {
      return WordsWidget.translatableItem(w, () => _select(w));
     }).toList();
  }

  List<WordItem> _knownTranslations(Word word) {
    final translations = VocabularyService.instance.translationsFor(word);
    return translations.map((t) {
      return WordsWidget.translatedItem(word, t, _onUnlearn);
     }).toList();
  }

  void _select(Word word) {
     setState(() {
       _selectedWord = word;
    });
  }

  void _onUnlearn() {
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