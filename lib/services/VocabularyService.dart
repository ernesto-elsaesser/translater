import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../model/LinguisticModel.dart';
export '../model/LinguisticModel.dart';

class VocabularyService with WidgetsBindingObserver {

  // Singleton
  static final VocabularyService instance = VocabularyService._private();
  VocabularyService._private();

  static final bool _useSampleData = true; // use only for testing

  Set<WordRelation> _rawRelations = Set();
  Map<Language, List<WordRelation>> _relationsFromLanguage = {};

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
    final json = jsonEncode(_rawRelations.toList());
    file.writeAsString(json);
    print("Saved vocabulary on disk (${_rawRelations.length} entries).");
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
      _rawRelations = data.map((list) => WordRelation.fromJson(list)).toSet();
      _rebuildLanguageLists();
      print("Loaded vocabulary from disk (${_rawRelations.length} entries).");
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
    _rawRelations.add(relation);
    _rebuildLanguageLists();
  }

  void unlearn(WordRelation relation) {
    _rawRelations.remove(relation);
    _rebuildLanguageLists();
  }

  WordRelation relationBetween(Word word, Word translation) {
    final identicalRelation = WordRelation(word, translation);
    return _rawRelations.firstWhere((r) => r == identicalRelation, orElse: () => null);
  }

  List<WordRelation> knownRelations(Language language) {
    return _relationsFromLanguage[language] ?? [];
  }

  int translationCount({DateTime before}) {
    if (before == null) {
      return _rawRelations.length;
    }
    return _rawRelations.where((r) => r.addedAt.isBefore(before)).length;
  }

  void _rebuildLanguageLists() {
    _relationsFromLanguage = {};
    for (final relation in _rawRelations) {
      final reverseRelation = WordRelation(relation.translation, relation.word);
      _addTranslationForLanguage(relation);
      _addTranslationForLanguage(reverseRelation);
    }
  }

  void _addTranslationForLanguage(WordRelation translation) {
    var languageList = _relationsFromLanguage[translation.word.language] ?? [];
    languageList.add(translation);
    _relationsFromLanguage[translation.word.language] = languageList;
  }
}
