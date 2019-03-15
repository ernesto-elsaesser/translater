class Language {
  String code;

  static final Language english = Language.fromCode('en');
  static final Language german = Language.fromCode('de');

  Language.fromCode(this.code);

  String toString() => code;
  int get hashCode => code.hashCode;
  bool operator ==(o) => o is Language && o.code == code;
}

class Configuration {
  Language from, to;
  Configuration(this.from, this.to);

  String toString() {
    return '${from.code.toUpperCase()} > ${to.code.toUpperCase()}';
  }
}

enum WordCategory { noun, verb, adjective, other }

class WordCategories {

  static WordCategory fromName(String categoryName) {
    switch (categoryName) {
      case "Noun":
        return WordCategory.noun;
      case "Verb":
        return WordCategory.verb;
      case "Adjective":
        return WordCategory.adjective;
      default:
        return WordCategory.other;
    }
  }

  static String name(WordCategory category) {
    switch (category) {
      case WordCategory.noun:
        return "Noun";
      case WordCategory.verb:
        return "Verb";
      case WordCategory.adjective:
        return "Adjective";
      case WordCategory.other:
        return "Other";
    }
  }
}

class Word implements Comparable<Word> {
  String text;
  Language language;
  WordCategory category;

  Word(this.text, this.language, this.category);

  int get hashCode => text.hashCode ^ language.hashCode;
  bool operator ==(o) => o is Word && o.text == text && o.language == language;
  int compareTo(Word other) => text.toLowerCase().compareTo(other.text.toLowerCase());
}

class TranslationOptions {
  Word word;
  List<Word> translations;

  TranslationOptions(this.word, this.translations);
}

class WordRelation implements Comparable<WordRelation> {
  Word word;
  Word translation;
  DateTime addedAt;
  WordCategory category;

  WordRelation(this.word, this.translation) : 
    addedAt = DateTime.now(),
    category = word.category;

  WordRelation.fromJson(List<dynamic> json) {
    int catIndex = json[4];
    category = WordCategory.values[catIndex];
    word = Word(json[0], Language.fromCode(json[1]), category);
    translation = Word(json[2], Language.fromCode(json[3]), category);
    addedAt = DateTime.parse(json[5]);
  }

  List<dynamic> toJson() {
    return [
      word.text, 
      word.language.code, 
      translation.text, 
      translation.language.code, 
      category.index,
      addedAt.toString()];
  }

  int get hashCode => word.hashCode ^ translation.hashCode;
  bool operator ==(o) { 
    if (!(o is WordRelation)) {
      return false;
    }
    if (o.word == word && o.translation == translation) {
      return true;
    } else if (o.word == translation && o.translation == word) {
      return true;
    } else {
      return false;
    }
  }
  int compareTo(WordRelation other) => word.compareTo(other.word);
}
