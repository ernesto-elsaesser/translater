import 'dart:async';

import '../model/VocabularyModel.dart';
import 'OfflineDictionaryService.dart';

abstract class DictionaryService {

  static final DictionaryService instance = OfflineDictionaryService();
  Future<List<TranslationOptions>> getTranslations(SearchDirection direction, String query);
}
