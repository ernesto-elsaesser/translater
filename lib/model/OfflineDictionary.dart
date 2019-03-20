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

  List<TranslationOptions> lookup(String query) {
    final matchingKeys = allTranslations.keys.where( (k) => k.contains(query) );
    return matchingKeys.map(_options).toList();
  }

  TranslationOptions _options(String entry) {
    final word = Word(entry, direction.from);
    final translations = allTranslations[entry];
    final translatedWords = translations.map((t) => Word(t, direction.to)).toList();
    return TranslationOptions(word, translatedWords);
  }
}