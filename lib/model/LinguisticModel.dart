enum Language { english, german }

String shortcode(Language language, {int length = 2, bool upper = false}) {
  String code = '';
  switch (language) {
    case Language.english: code = 'english'; break;
    case Language.german: code = 'deutsch'; break;
  }
  if (upper) {
    code = code.toUpperCase();
  }
  return code.substring(0, length);
}

class SearchDirection {
  Language from, to;
  SearchDirection(this.from, this.to);

  String toString() => "${shortcode(from, upper: true)} > ${shortcode(to, upper: true)}";
  int get hashCode => from.index * 100 + to.index;
  bool operator ==(o) => o is SearchDirection && o.hashCode == hashCode;
}

enum WordCategory { noun, verb, adjective, unknown }

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
        return WordCategory.unknown;
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
      case WordCategory.unknown:
        return "Unknown";
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
    word = Word(json[0], Language.values[json[1]], category);
    translation = Word(json[2], Language.values[json[3]], category);
    addedAt = DateTime.parse(json[5]);
  }

  List<dynamic> toJson() {
    return [
      word.text, 
      word.language.index, 
      translation.text, 
      translation.language.index, 
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
