import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse {
  final List<Entry> results;

  ApiResponse(this.results);

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonResults = json['results'];
    List<Entry> results = jsonResults.map( (e) => Entry.fromJson(e) ).toList();
    return ApiResponse(results);
  }
}

class Entry {
  final String id;
  final String language;
  final String type;
  final String word;

  Entry({this.id, this.language, this.type, this.word});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      language: json['lanugage'],
      type: json['type'],
      word: json['word']
    );
  }
}

class DictionaryService {

  String from;
  String to;

  DictionaryService(this.from, this.to);

  Future<List<Entry>> getEntries(String word) async {

    String path = 'entries/$from/$word';
    ApiResponse res = await _request(path);
    return res.results;
  }

  Future<List<Entry>> getTranslations(Entry entry) async {

    String path = 'entries/$from/${entry.id}/translations=$to';
    ApiResponse res = await _request(path);
    return res.results; // TODO: parse translations
  }

  Future<ApiResponse> _request(String subpath) async {

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

    var jsonDict = json.decode(response.body);
    return ApiResponse.fromJson(jsonDict);
  }
}