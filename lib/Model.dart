
abstract class ListPresentable {
  String titleInList();
}

class SearchResponse {
	List<SearchResult> results;

	SearchResponse({this.results});

	SearchResponse.fromJson(Map<String, dynamic> json) {
		if (json['results'] != null) {
			results = List<SearchResult>();
			json['results'].forEach((v) { results.add(SearchResult.fromJson(v)); });
		}
	}
}

class SearchResult implements ListPresentable
{
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

class TranslationsResponse {
	List<HeadwordEntry> results;

	TranslationsResponse({this.results});

	TranslationsResponse.fromJson(Map<String, dynamic> json) {
		if (json['results'] != null) {
			results = List<HeadwordEntry>();
			json['results'].forEach((v) { results.add(HeadwordEntry.fromJson(v)); });
		}
	}
}

class HeadwordEntry {
	String id;
	String language;
	List<LexicalEntry> lexicalEntries;
	List<Pronunciation> pronunciations;
	String type;
	String word;

	HeadwordEntry({this.id, this.language, this.lexicalEntries, this.pronunciations, this.type, this.word});

	HeadwordEntry.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		language = json['language'];
		if (json['lexicalEntries'] != null) {
			lexicalEntries = List<LexicalEntry>();
			json['lexicalEntries'].forEach((v) { lexicalEntries.add(LexicalEntry.fromJson(v)); });
		}
		if (json['pronunciations'] != null) {
			pronunciations = List<Pronunciation>();
			json['pronunciations'].forEach((v) { pronunciations.add(Pronunciation.fromJson(v)); });
		}
		type = json['type'];
		word = json['word'];
	}
}

class LexicalEntry {
	List<Derivative> derivativeOf;
	List<Derivative> derivatives;
	List<Entry> entries;
	List<GrammaticalFeature> grammaticalFeatures;
	String language;
	String lexicalCategory;
	List<Note> notes;
	List<Pronunciation> pronunciations;
	String text;
	List<VariantForm> variantForms;

	LexicalEntry({this.derivativeOf, this.derivatives, this.entries, this.grammaticalFeatures, this.language, this.lexicalCategory, this.notes, this.pronunciations, this.text, this.variantForms});

	LexicalEntry.fromJson(Map<String, dynamic> json) {
		if (json['derivativeOf'] != null) {
			derivativeOf = List<Derivative>();
			json['derivativeOf'].forEach((v) { derivativeOf.add(Derivative.fromJson(v)); });
		}
		if (json['derivatives'] != null) {
			derivatives = List<Derivative>();
			json['derivatives'].forEach((v) { derivatives.add(Derivative.fromJson(v)); });
		}
		if (json['entries'] != null) {
			entries = List<Entry>();
			json['entries'].forEach((v) { entries.add(Entry.fromJson(v)); });
		}
		if (json['grammaticalFeatures'] != null) {
			grammaticalFeatures = List<GrammaticalFeature>();
			json['grammaticalFeatures'].forEach((v) { grammaticalFeatures.add(GrammaticalFeature.fromJson(v)); });
		}
		language = json['language'];
		lexicalCategory = json['lexicalCategory'];
		if (json['notes'] != null) {
			notes = List<Note>();
			json['notes'].forEach((v) { notes.add(Note.fromJson(v)); });
		}
		if (json['pronunciations'] != null) {
			pronunciations = List<Pronunciation>();
			json['pronunciations'].forEach((v) { pronunciations.add(Pronunciation.fromJson(v)); });
		}
		text = json['text'];
		if (json['variantForms'] != null) {
			variantForms = List<VariantForm>();
			json['variantForms'].forEach((v) { variantForms.add(VariantForm.fromJson(v)); });
		}
	}
}

class Derivative {
	List<String> domains;
	String id;
	String language;
	List<String> regions;
	List<String> registers;
	String text;

	Derivative({this.domains, this.id, this.language, this.regions, this.registers, this.text});

	Derivative.fromJson(Map<String, dynamic> json) {
		domains = json['domains'].cast<String>();
		id = json['id'];
		language = json['language'];
		regions = json['regions'].cast<String>();
		registers = json['registers'].cast<String>();
		text = json['text'];
	}
}

class Entry {
	List<GrammaticalFeature> grammaticalFeatures;
	String homographNumber;
	List<Sense> senses;

	Entry({this.grammaticalFeatures, this.homographNumber, this.senses});

	Entry.fromJson(Map<String, dynamic> json) {
		if (json['grammaticalFeatures'] != null) {
			grammaticalFeatures = List<GrammaticalFeature>();
			json['grammaticalFeatures'].forEach((v) { grammaticalFeatures.add(GrammaticalFeature.fromJson(v)); });
		}
		homographNumber = json['homographNumber'];
		if (json['senses'] != null) {
			senses = List<Sense>();
			json['senses'].forEach((v) { senses.add(Sense.fromJson(v)); });
		}
	}
}

class GrammaticalFeature {
	String text;
	String type;

	GrammaticalFeature({this.text, this.type});

	GrammaticalFeature.fromJson(Map<String, dynamic> json) {
		text = json['text'];
		type = json['type'];
	}
}

class Note {
	String id;
	String text;
	String type;

	Note({this.id, this.text, this.type});

	Note.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		text = json['text'];
		type = json['type'];
	}
}

class Pronunciation {
	String audioFile;
	List<String> dialects;
	String phoneticNotation;
	String phoneticSpelling;

	Pronunciation({this.audioFile, this.dialects, this.phoneticNotation, this.phoneticSpelling});

	Pronunciation.fromJson(Map<String, dynamic> json) {
		audioFile = json['audioFile'];
		dialects = json['dialects'].cast<String>();
		phoneticNotation = json['phoneticNotation'];
		phoneticSpelling = json['phoneticSpelling'];
	}
}

class Sense {
	List<String> definitions;
	List<Example> examples;
	String id;
	List<Note> notes;
	List<String> shortDefinitions;
	List<Sense> subsenses;
	List<ThesaurusLink> thesaurusLinks;
	List<Translation> translations;

	Sense({this.definitions, this.examples, this.id, this.notes, this.shortDefinitions, this.subsenses, this.thesaurusLinks, this.translations});

	Sense.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		translations = List<Translation>();
		if (json['translations'] != null) {
			json['translations'].forEach((v) { translations.add(Translation.fromJson(v)); });
		}
    if (json['definitions'] != null) {
		  definitions = json['definitions'].cast<String>();
		}
    if (json['short_definitions'] != null) {
		  shortDefinitions = json['short_definitions'].cast<String>();
		}
		if (json['examples'] != null) {
			examples = List<Example>();
			json['examples'].forEach((v) { examples.add(Example.fromJson(v)); });
		}
		if (json['notes'] != null) {
			notes = List<Note>();
			json['notes'].forEach((v) { notes.add(Note.fromJson(v)); });
		}
		if (json['subsenses'] != null) {
			subsenses = List<Sense>();
			json['subsenses'].forEach((v) { subsenses.add(Sense.fromJson(v)); });
		}
		if (json['thesaurusLinks'] != null) {
			thesaurusLinks = List<ThesaurusLink>();
			json['thesaurusLinks'].forEach((v) { thesaurusLinks.add(ThesaurusLink.fromJson(v)); });
		}
	}
}

class Example {
	String text;

	Example({this.text});

	Example.fromJson(Map<String, dynamic> json) {
		text = json['text'];
	}
}

class Translation implements ListPresentable {
	String language;
	String text;

	Translation({this.language, this.text});

	Translation.fromJson(Map<String, dynamic> json) {
		language = json['language'];
		text = json['text'];
	}

  String titleInList() {
    return text;
  }
}

class ThesaurusLink {
	String entryId;
	String senseId;

	ThesaurusLink({this.entryId, this.senseId});

	ThesaurusLink.fromJson(Map<String, dynamic> json) {
		entryId = json['entry_id'];
		senseId = json['sense_id'];
	}
}

class VariantForm {
	List<String> regions;
	String text;

	VariantForm({this.regions, this.text});

	VariantForm.fromJson(Map<String, dynamic> json) {
		regions = json['regions'].cast<String>();
		text = json['text'];
	}
}