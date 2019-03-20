import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

import 'DictionaryService.dart';
import 'ConfigurationService.dart';
import 'package:translater/model/VocabularyModel.dart';

class OfflineDictionaryService extends DictionaryService {

  Map<SearchDirection, Map<String, List<TranslationOptions>>> dictionaries = {};

  OfflineDictionaryService() {
    final from = ConfigurationService.sourceLanguage;
    final to = ConfigurationService.targetLanguage;
    _preloadDictionaryFromAssets(from, to);
    _preloadDictionaryFromAssets(to, from);
  }

  void _preloadDictionaryFromAssets(Language from, Language to) async {
    final direction = SearchDirection(from, to);
    final fileName = _langageCode(from) + '-' + _langageCode(to);
    try {
      String xml = await rootBundle.loadString('assets/$fileName.tei');
      // TODO: implement XML parsing
      dictionaries[direction] = {};
    } catch (e) {
      print("Loading dictionary from disk failed: $e");
    }
  }

  String _langageCode(Language language) {
    switch (language) {
      case Language.english: return 'eng';
      case Language.german: return 'deu';
    }
  }
  
  @override
  Future<List<TranslationOptions>> getTranslations(SearchDirection direction, String query) {
    return Future.value(_optionsFor(direction, query));
  }

  List<TranslationOptions> _optionsFor(SearchDirection direction, String query) {
    final dictionary = dictionaries[direction];
    if (dictionary == null) {
      return [];
    }
    final options = dictionary[query];
    if (options == null) {
      return [];
    }
    return options;
  }

}