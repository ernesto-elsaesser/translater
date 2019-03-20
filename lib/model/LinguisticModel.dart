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

class Word implements Comparable<Word> {
  String text;
  Language language;

  Word(this.text, this.language);

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

  WordRelation(this.word, this.translation) : 
    addedAt = DateTime.now();

  WordRelation.fromJson(List<dynamic> json) {
    word = Word(json[0], Language.values[json[1]]);
    translation = Word(json[2], Language.values[json[3]]);
    addedAt = DateTime.parse(json[4]);
  }

  List<dynamic> toJson() {
    return [
      word.text, 
      word.language.index, 
      translation.text, 
      translation.language.index,
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
