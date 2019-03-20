import 'dart:async';

import '../model/LinguisticModel.dart';
export '../model/LinguisticModel.dart';

abstract class DictionaryService {

  static DictionaryService instance;
  Future<List<TranslationOptions>> getTranslations(String query);
}
