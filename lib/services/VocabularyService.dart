import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../model/Configuration.dart';

class WordRelation {
  String word1;
  String language1;
  String word2;
  String language2;

  WordRelation({this.word1, this.language1, this.word2, this.language2});

  WordRelation.fromJson(List<dynamic> json)
      : word1 = json[0], language1 = json[1], word2 = json[2], language2 = json[3];

  List<String> toJson() => [word1, language1, word2, language2];
}

class VocabularyService with WidgetsBindingObserver {

  // Singleton
  static final VocabularyService instance = VocabularyService._private();
  VocabularyService._private();

  List<WordRelation> _relations = [];
  Map<String, Map<String, WordRelation>> _knownWords = {}; // word -> language -> relation

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
    String json = jsonEncode(_relations);
    file.writeAsString(json);
    print("Saved vocabulary on disk (${_relations.length} entries).");
  }

  void _loadFromDisk() async {
    try {
      final file = await _vocabularyFile();
      String json = await file.readAsString();
      List<dynamic> data = jsonDecode(json);
      _relations = data.map( (list) => WordRelation.fromJson(list) ).toList();
      print("Loaded vocabulary from disk (${_relations.length} entries).");
    } catch (e) {
      print("Loading vocabulary from disk failed: $e");
      return;
    }
    _updateKnownWords();
  }

  Future<File> _vocabularyFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path =  directory.path;
    return File('$path/vocabulary.txt');
  }

  void learn(String wordFrom, String wordTo, Configuration config) {
    WordRelation relation = WordRelation(
      word1: wordFrom.toLowerCase(), 
      language1: config.from,
      word2: wordTo.toLowerCase(), 
      language2: config.to
    );
    _relations.add(relation);
    _updateKnownWords();
  }

  void unlearn(String word, String language) {
    Map<String, WordRelation> entries = _knownWords[word.toLowerCase()];
    if (entries == null) {
      return;
    }
    WordRelation relation = entries[language];
    if (relation == null) {
      return;
    }
    _relations.remove(relation);
    _updateKnownWords();
  }

  bool contains(String word, String language) {
    Map<String, WordRelation> entries = _knownWords[word.toLowerCase()];
    if (entries == null) {
      return false;
    }
    return entries[language] != null;
  }

  void _updateKnownWords() {
    _knownWords = {};
    for (var relation in _relations) {
      _addToKnownWords(relation.word1, relation.language1, relation);
      _addToKnownWords(relation.word2, relation.language2, relation);
    }
  }

  void _addToKnownWords(String word, String language, WordRelation relation) {
    Map<String, WordRelation> entries = _knownWords[word];
    if (entries == null) {
      _knownWords[word] = {language: relation};
    } else {
      entries[language] = relation;
      _knownWords[word] = entries;
    }
  }
}