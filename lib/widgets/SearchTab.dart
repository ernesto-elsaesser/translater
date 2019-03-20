import 'package:flutter/cupertino.dart';

import '../services/DictionaryService.dart';
import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'WordList.dart';
import 'BilingualSearchField.dart';

class SearchTab extends StatefulWidget {
  @override
  SearchTabState createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  
  bool _isLoading = false;
  List<TranslationOptions> _results;

  @override
  Widget build(BuildContext context) {
    final searchBar = BilingualSearchField(_lookup);
    List<Widget> sections = [searchBar];

    if (_isLoading) {
      final loadingIndicator = Expanded(
          child: Center(child: CupertinoActivityIndicator(radius: 15.0)));
      sections.add(loadingIndicator);
    } else if (_results != null) {
      final searchResults = Flexible(child: _buildResultList());
      sections.add(searchResults);
    }

    return SectionedTab(sections);
  }

  Widget _buildResultList() {
    final items = _results.expand( (tw) {
      List<WordItem> items = [_makeHeader(tw.word)];
      final addableItems = tw.translations.map((t) => _makeItem(tw.word, t) ).toList();
      items.addAll(addableItems);
      return items;
    }).toList();
    return WordList(items, emptyText: "No results.",);
  }

  HeaderItem _makeHeader(Word word) {
    final languageCode = Languages.shortcode(word.language);
    final categoryName = WordCategories.name(word.category);
    final text = "$languageCode: ${word.text} [$categoryName]";
    return HeaderItem(text: text);
  }

  AddableItem _makeItem(Word word, Word translation) {
    final vocabulary = VocabularyService.instance;
    VoidCallback onTap = () {
      final relation = vocabulary.relationBetween(word, translation);
      if (relation != null) {
        vocabulary.unlearn(relation);
      } else {
        vocabulary.learn(word, translation);
      }
      setState(() {});
    };
    return AddableItem(
      text: translation.text, 
      isAdded: () => vocabulary.relationBetween(word, translation) != null,
      onTap: onTap);
  }

  void _lookup(SearchDirection direction, String query) async {
    if (query.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final results = await DictionaryService.instance.getTranslations(direction, query);
    setState(() {
      _isLoading = false;
      _results = results;
    });
  }
}
