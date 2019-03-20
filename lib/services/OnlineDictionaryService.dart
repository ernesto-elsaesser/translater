import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'DictionaryService.dart';
import 'ConfigurationService.dart';
import '../model/OxfordDictionaryModel.dart';

class OnlineDictionaryService extends DictionaryService {

  @override
  Future<List<TranslationOptions>> getTranslations(String query) async {
    final directions = ConfigurationService.supportedDirections;
    final requests = directions.map( (dir) => _fetchTranslations(dir, query) );
    final results = await Future.wait(requests);
    return results.expand( (r) => r ).toList();
  }

  Future<List<TranslationOptions>> _fetchTranslations(SearchDirection dir, String query) async {
    final path = 'entries/${shortcode(dir.from)}/$query/translations=${shortcode(dir.to)}';
    final json = await _request(path);
    if (json == null) {
      return [];
    }
    final res = TranslationsResponse.fromJson(json);
    final entries = res.results.expand((r) => r.lexicalEntries);
    return entries.map((le) => _parseLexicalEntry(le, dir)).toList();
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

  TranslationOptions _parseLexicalEntry(LexicalEntry entry, SearchDirection direction) {
    final word = Word(entry.text, direction.from);
    final rawTranslations =
        entry.entries.expand((e) => e.senses).expand((s) => s.translations);
    final translations =
        rawTranslations.map((t) => Word(t.text, direction.to)).toList();
    return TranslationOptions(word, translations);
  }
}
