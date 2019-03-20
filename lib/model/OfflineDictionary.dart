import 'LinguisticModel.dart';

class OfflineDictionary {

  final SearchDirection direction;
  Map<String, List<String>> allTranslations = {};

  OfflineDictionary(this.direction);

  void insert(String word, String translation) {
    var wordTranslations = allTranslations[word];
    if (wordTranslations == null) {
      wordTranslations = [translation];
    } else {
      wordTranslations.add(translation);
    }
    allTranslations[word] = wordTranslations;
  }

  TranslationOptions lookup(String query) {
    final results = allTranslations[query];
    if (results == null) return null;
    final word = Word(query, direction.from);
    final translations = results.map((t) => Word(t, direction.to)).toList();
    return TranslationOptions(word, translations);
  }
}