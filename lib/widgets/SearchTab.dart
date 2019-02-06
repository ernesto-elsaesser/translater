import 'package:flutter/cupertino.dart';

import '../services/DictionaryService.dart';
import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'WordList.dart';
import 'SplitBox.dart';

class SearchTab extends StatefulWidget {
  @override
  SearchTabState createState() => new SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  
  bool _isLoading = false;
  List<TranslationOptions> _results;

  @override
  Widget build(BuildContext context) {
    final searchBar = SplitBox(
      _buildSearchField(Configuration.englishToGerman),
      _buildSearchField(Configuration.germanToEnglish)
    );

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

  Widget _buildSearchField(Configuration config) {
    return Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder: config.toString(),
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => _lookup(config, q)));
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
    final languageCode = word.language.code.toUpperCase();
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

  void _lookup(Configuration config, String query) async {
    if (query.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final results = await DictionaryService.instance.getTranslations(config, query);
    setState(() {
      _isLoading = false;
      _results = results;
    });
  }
}
