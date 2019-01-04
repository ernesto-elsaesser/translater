class SearchResponse {
  List<SearchResult> results;

  SearchResponse({this.results});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = List<SearchResult>();
      json['results'].forEach((v) {
        results.add(SearchResult.fromJson(v));
      });
    }
  }
}

class SearchResult {
  String matchString;
  String matchType;
  String word;
  String region;
  String inflectionId;
  String id;
  double score;

  SearchResult(
      {this.matchString,
      this.matchType,
      this.word,
      this.region,
      this.inflectionId,
      this.id,
      this.score});

  SearchResult.fromJson(Map<String, dynamic> json) {
    matchString = json['matchString'];
    matchType = json['matchType'];
    word = json['word'];
    region = json['region'];
    inflectionId = json['inflection_id'];
    id = json['id'];
    score = json['score'];
  }

  String titleInList() {
    return word;
  }
}
