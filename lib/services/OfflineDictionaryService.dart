import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'DictionaryService.dart';
import 'ConfigurationService.dart';
import '../model/OfflineDictionary.dart';

class OfflineDictionaryService extends DictionaryService {

  Map<SearchDirection, OfflineDictionary> dictionaries = {};

  OfflineDictionaryService() {
    final source = ConfigurationService.sourceLanguage;
    final target = ConfigurationService.targetLanguage;
    _loadDictionaryFromAssets(source, target);
    _loadDictionaryFromAssets(target,source);
  }
  
  @override
  Future<List<TranslationOptions>> getTranslations(SearchDirection direction, String query) {
    List<TranslationOptions> translations = [];
    final dictionary = dictionaries[direction];
    if (dictionary != null) {
      translations = dictionary.lookup(query);
    }
    return Future.value(translations);
  }

  void _loadDictionaryFromAssets(Language from, Language to) async {
    final direction = SearchDirection(from, to);
    final fileName = shortcode(from, length: 3) + '-' + shortcode(to, length: 3);
    try {
      final csvString = await rootBundle.loadString('assets/$fileName.csv');
      final wordMap = _parseCSV(csvString);
      final dictionary = OfflineDictionary(direction, wordMap);
      dictionaries[direction] = dictionary;
      print("Loaded $direction dictionary from CSV (${wordMap.length} entries)");
    } catch (e) {
      print("Loading $direction dictionary from CSV failed: $e");
    }
  }

  Map<String, String> _parseCSV(String csvString) {
    Map<String, String> map = {};
    csvString.split('\n').forEach( (line) {
      final parts = line.split('\t');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    });
    return map;
  }
}