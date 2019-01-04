import '../model/Configuration.dart';

class WordRelation {
  String word1;
  String language1;
  String word2;
  String language2;

  WordRelation({this.word1, this.language1, this.word2, this.language2});
}

class VocabularyService {

  // Singleton
  static final VocabularyService shared = VocabularyService._private();
  VocabularyService._private();

  List<WordRelation> _relations = [];
  Map<String, Map<String, WordRelation>> _knownWords = {}; // word -> language -> relation

  void store() {
    // TODO: implement
  }

  void restore() {
    // TODO: implement
    _updateKnownWords();
  }

  void learn(String wordFrom, String wordTo, Configuration config) {
    WordRelation relation = WordRelation(
      word1: wordFrom.toLowerCase(), 
      language1: config.from,
      word2: wordTo.toLowerCase(), 
      language2: config.to
    );
    _relations.add(relation);
    _updateKnownWords();
  }

  void unlearn(String word, String language) {
    Map<String, WordRelation> entries = _knownWords[word.toLowerCase()];
    if (entries == null) {
      return;
    }
    WordRelation relation = entries[language];
    if (relation == null) {
      return;
    }
    _relations.remove(relation);
    _updateKnownWords();
  }

  bool inVocabulary(String word, String language) {
    Map<String, WordRelation> entries = _knownWords[word.toLowerCase()];
    if (entries == null) {
      return false;
    }
    return entries[language] != null;
  }

  void _updateKnownWords() {
    _knownWords = {};
    for (var relation in _relations) {
      _addToKnownWords(relation.word1, relation.language1, relation);
      _addToKnownWords(relation.word2, relation.language2, relation);
    }
  }

  void _addToKnownWords(String word, String language, WordRelation relation) {
    Map<String, WordRelation> entries = _knownWords[word];
    if (entries == null) {
      _knownWords[word] = {language: relation};
    } else {
      entries[language] = relation;
      _knownWords[word] = entries;
    }
  }
}