import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'DictionaryService.dart';
import '../model/OxfordDictionaryModel.dart';

class OnlineDictionaryService extends DictionaryService {

  @override
  Future<List<TranslationOptions>> getTranslations(SearchDirection direction, String query) async {
    final fromCode = shortcode(direction.from);
    final toCode = shortcode(direction.to);
    final path = 'entries/$fromCode/$query/translations=$toCode';
    final json = await _request(path);
    if (json == null) {
      return [];
    }
    final res = TranslationsResponse.fromJson(json);
    final entries = res.results.expand((r) => r.lexicalEntries);
    return entries.map((le) => _parseLexicalEntry(le, direction)).toList();
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
