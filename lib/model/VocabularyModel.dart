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

class Word {
  String text;
  Language language;

  Word(this.text, this.language);

  int get hashCode => text.hashCode ^ language.hashCode;
  bool operator ==(o) => o is Word && o.text == text && o.language == language;
}

class WordRelation {
  Word word1, word2;

  WordRelation(this.word1, this.word2);

  bool relates(Word word) => word == word1 || word == word2;

  WordRelation.fromJson(List<dynamic> json)
      : word1 = Word(json[0], Language.fromCode(json[1])),
        word2 = Word(json[2], Language.fromCode(json[3]));

  List<String> toJson() => [word1.text, word1.language.code, word2.text, word2.language.code];

  int get hashCode => word1.hashCode ^ word2.hashCode;
  bool operator ==(o) => o is WordRelation && 
    ((o.word1 == word1 && o.word2 == word2) || (o.word1 == word2 && o.word2 == word1));
}
