import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/OxfordDictionaryModel.dart';
import '../model/VocabularyModel.dart';

class DictionaryService {
  // Singleton
  static final DictionaryService instance = DictionaryService._private();
  DictionaryService._private();

  Future<List<TranslatedWord>> getTranslations(
      Configuration config, String headword) async {
    final path = 'entries/${config.from}/$headword/translations=${config.to}';
    final json = await _request(path);
    if (json == null) {
      return [];
    }
    final res = TranslationsResponse.fromJson(json);
    final entries = res.results.expand((r) => r.lexicalEntries);
    return entries.map((le) => _parseLexicalEntry(le, config)).toList();
  }

  Future<Map<String, dynamic>> _request(String subpath) async {
    final url = 'https://od-api.oxforddictionaries.com:443/api/v1/$subpath';
    final headers = {
      "Accept": "application/json",
      "app_id": "59a12a71",
      "app_key": "8d12fd6f89f0e8e76d6a039dbccf0bd0"
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      return null;
    }
    return json.decode(response.body);
  }

  TranslatedWord _parseLexicalEntry(LexicalEntry entry, Configuration config) {
    final category = WordCategories.fromName(entry.lexicalCategory);
    final word = Word(entry.text, config.from, category);
    final rawTranslations =
        entry.entries.expand((e) => e.senses).expand((s) => s.translations);
    final translations =
        rawTranslations.map((t) => Word(t.text, config.to, category)).toList();
    return TranslatedWord(word, translations);
  }
}
