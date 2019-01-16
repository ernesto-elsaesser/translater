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

  static Configuration germanToEnglish = Configuration._private(Language.german, Language.english);
  static Configuration englishToGerman = Configuration._private(Language.english, Language.german);

  Configuration._private(this.from, this.to);

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

class Word {
  String text;
  Language language;
  WordCategory category;

  Word(this.text, this.language, this.category);

  int get hashCode => text.hashCode ^ language.hashCode;
  bool operator ==(o) => o is Word && o.text == text && o.language == language;
}

class TranslatedWord {
  Word word;
  List<Word> translations;

  TranslatedWord(this.word, this.translations);
}

class WordRelation {
  Word word1, word2;
  DateTime creationDate;
  WordCategory category;

  WordRelation(this.word1, this.word2) : 
    creationDate = DateTime.now(),
    category = word1.category;

  WordRelation.fromJson(List<dynamic> json) {
    int catIndex = json[4];
    category = WordCategory.values[catIndex];
    word1 = Word(json[0], Language.fromCode(json[1]), category);
    word2 = Word(json[2], Language.fromCode(json[3]), category);
    creationDate = DateTime.parse(json[5]);
  }

  List<dynamic> toJson() {
    return [
      word1.text, 
      word1.language.code, 
      word2.text, 
      word2.language.code, 
      category.index,
      creationDate.toString()];
  }

  Word wordIn(Language language) {
    if (word1.language == language) {
      return word1;
    } else if (word2.language == language) {
      return word2;
    } else {
      return null;
    }
  }

  int get hashCode => word1.hashCode ^ word2.hashCode;
  bool operator ==(o) => o is WordRelation && 
    ((o.word1 == word1 && o.word2 == word2) || (o.word1 == word2 && o.word2 == word1));
}
