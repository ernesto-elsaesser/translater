import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Model.dart';

class DictionaryService {

  String from;
  String to;

  DictionaryService(this.from, this.to);

  Future<List<SearchResult>> searchHeadwords(String query) async {

    String path = 'search/$from?q=$query&prefix=true';
    Map<String,dynamic> json = await _request(path);
    SearchResponse res = SearchResponse.fromJson(json);
    return res.results;
  }

  Future<List<Translation>> getTranslations(SearchResult result) async {

    String path = 'entries/$from/${result.id}/translations=$to';
    Map<String,dynamic> json = await _request(path);
    TranslationsResponse res = TranslationsResponse.fromJson(json);
    return res.results
      .expand( (r) => r.lexicalEntries )
      .expand( (le) => le.entries )
      .expand( (e) => e.senses )
      .expand( (s) => s.translations )
      .toList();
  }

  Future<Map<String,dynamic>> _request(String subpath) async {

    String url = 'https://od-api.oxforddictionaries.com:443/api/v1/$subpath';

    Map<String, String> headers =  {
      "Accept": "application/json",
      "app_id": "59a12a71",
      "app_key": "8d12fd6f89f0e8e76d6a039dbccf0bd0"
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Request failed!');
    }

    return json.decode(response.body);
  }
}