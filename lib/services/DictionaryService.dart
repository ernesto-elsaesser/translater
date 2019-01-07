import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/OxfordDictionaryModel.dart';
export '../model/OxfordDictionaryModel.dart';
import '../model/VocabularyModel.dart';
export '../model/VocabularyModel.dart';

class DictionaryService {
  // Singleton
  static final DictionaryService instance = DictionaryService._private();
  DictionaryService._private();

  Future<List<SearchResult>> searchHeadwords(
      Configuration config, String query) async {
    final path =
        'search/${config.from}/translations=${config.to}?q=$query&prefix=true';
    final json = await _request(path);
    final res = SearchResponse.fromJson(json);
    return res.results;
  }

  Future<List<Translation>> getTranslations(
      Configuration config, String headword) async {
    final path =
        'entries/${config.from}/$headword/translations=${config.to}';
    final json = await _request(path);
    final res = TranslationsResponse.fromJson(json);
    return res.results
        .expand((r) => r.lexicalEntries)
        .expand((le) => le.entries)
        .expand((e) => e.senses)
        .expand((s) => s.translations)
        .toList();
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
      throw Exception('API request failed!');
    }
    return json.decode(response.body);
  }
}
