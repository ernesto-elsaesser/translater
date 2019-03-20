import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'DictionaryService.dart';
import 'ConfigurationService.dart';
import '../model/OfflineDictionary.dart';

class OfflineDictionaryService extends DictionaryService {

  List<OfflineDictionary> dictionaries = [];

  OfflineDictionaryService() {
    ConfigurationService.supportedDirections.forEach(_loadDictionaryFromAssets);
  }
  
  @override
  Future<List<TranslationOptions>> getTranslations(String query) {
    final results = dictionaries.map( (d) => d.lookup(query) ).where( (r) => r != null ).toList();
    return Future.value(results);
  }

  void _loadDictionaryFromAssets(SearchDirection direction) async {
    final dictionary = OfflineDictionary(direction);
    final fileName = shortcode(direction.from, length: 3) + '-' + shortcode(direction.to, length: 3);
    try {
      final csvString = await rootBundle.loadString('assets/$fileName.csv');
      _importCSV(csvString, dictionary);
      dictionaries.add(dictionary);
      print("Loaded $direction dictionary from CSV");
    } catch (e) {
      print("Loading $direction dictionary from CSV failed: $e");
    }
  }

  void _importCSV(String csvString, OfflineDictionary dictionary) {
    csvString.split('\n').forEach( (line) {
      final parts = line.split('\t');
      if (parts.length != 2) return;
      dictionary.insert(parts[0], parts[1]);
    });
  }
}