import '../model/LinguisticModel.dart';
export '../model/LinguisticModel.dart';

class ConfigurationService {

  static Language sourceLanguage = Language.german;
  static Language targetLanguage = Language.english;

  static List<SearchDirection> supportedDirections = [
    SearchDirection(Language.german, Language.english),
    SearchDirection(Language.english, Language.german)
  ];
}
