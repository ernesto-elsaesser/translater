import 'LinguisticModel.dart';

class OfflineDictionary {

  final SearchDirection direction;
  final Map<String, String> translations;

  OfflineDictionary(this.direction, this.translations);

  List<TranslationOptions> lookup(String query) {
    final result = translations[query];
    if (result == null) return [];
    final word = Word(query, direction.from, WordCategory.unknown); // TODO: category?
    final translation = Word(result, direction.to, word.category);
    final options = TranslationOptions(word, [translation]);
    return [options];
  }
}