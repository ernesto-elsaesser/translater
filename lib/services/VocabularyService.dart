import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../model/VocabularyModel.dart';
export '../model/VocabularyModel.dart';

class VocabularyService with WidgetsBindingObserver {

  // Singleton
  static final VocabularyService instance = VocabularyService._private();
  VocabularyService._private();

  static final bool _useSampleData = true; // use only for testing

  Set<WordRelation> _relations = Set();
  Map<Language, Map<String, TranslatedWord>> _lookupIndex = {};

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _loadFromDisk();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _writeToDisk();
    }
  }

  void _writeToDisk() async {
    final file = await _vocabularyFile();
    final json = jsonEncode(_relations.toList());
    file.writeAsString(json);
    print("Saved vocabulary on disk (${_relations.length} entries).");
  }

  void _loadFromDisk() async {
    try {
      String json;
      if (_useSampleData) {
        json = await rootBundle.loadString('assets/sampledata.json');
      } else {
        final file = await _vocabularyFile();
        json = await file.readAsString();
      }
      List<dynamic> data = jsonDecode(json);
      _relations = data.map((list) => WordRelation.fromJson(list)).toSet();
      _rebuildIndex();
      print("Loaded vocabulary from disk (${_relations.length} entries).");
    } catch (e) {
      print("Loading vocabulary from disk failed: $e");
    }
  }

  Future<File> _vocabularyFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/vocabulary.txt');
  }

  void learn(Word word, Word translation) {
    final relation = WordRelation(word, translation);
    _relations.add(relation);
    _rebuildIndex();
  }

  void unlearn(Word word, Word translation) {
    final relation = WordRelation(word, translation);
    _relations.remove(relation);
    _rebuildIndex();
  }

  bool contains(Word word) {
    final strings = _lookupIndex[word.language];
    if (strings == null) {
      return false;
    }
    return strings.containsKey(word.text);
  }

  List<TranslatedWord> knownTranslations(Language language) {
    final strings = _lookupIndex[language];
    if (strings == null) {
      return [];
    }
    return strings.values.toList();
  }

  Map<WordCategory, List<Word>> categorizedWords(Language language) {
    Map<WordCategory, List<Word>> words = {};
    for (final cat in WordCategory.values) {
      words[cat] = [];
    }
    for (final r in _relations) {
      words[r.category].add(r.wordIn(language));
    }
    return words;
  }

  int translationCount({DateTime before}) {
    if (before == null) {
      return _relations.length;
    }
    return _relations.where((r) => r.creationDate.isBefore(before)).length;
  }

  void _rebuildIndex() {
    _lookupIndex = {};
    for (final relation in _relations) {
      _addToIndex(relation.word1, relation.word2);
      _addToIndex(relation.word2, relation.word1);
    }
  }

  void _addToIndex(Word word, Word translation) {
    var strings = _lookupIndex[word.language] ?? {};
    var translatedWord = strings[word.text];
    if (translatedWord == null) {
      translatedWord = TranslatedWord(word, [translation]);
    } else {
      translatedWord.translations.add(translation);
    }
    strings[word.text] = translatedWord;
    _lookupIndex[word.language] = strings;
  }
}
