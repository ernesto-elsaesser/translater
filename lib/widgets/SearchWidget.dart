import 'package:flutter/cupertino.dart';

import '../services/DictionaryService.dart';
import 'WordsWidget.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  
  bool _isLoading = false;
  List<WordItem> _wordItems = [];
  SearchResult _selectedResult;
  Configuration _activeConfig;

  @override
  Widget build(BuildContext context) {
    final searchBar = Container(
        padding: EdgeInsets.all(10.0),
        color: CupertinoColors.lightBackgroundGray,
        child: Row(children: <Widget>[
          _buildSearchField(Configuration.englishToGerman),
          SizedBox(width: 10.0),
          _buildSearchField(Configuration.germanToEnglish)
        ]));

    List<Widget> sections = [searchBar];

    if (_selectedResult != null) {
      final selectionText = "$_activeConfig: ${_selectedResult.word}";
      final selectionBar = Container(
          color: Color(0xFFEEEEEE),
          padding: EdgeInsets.all(10.0),
          child: Center(child: Text(selectionText)));
      sections.add(selectionBar);
    }

    if (_isLoading) {
      final loadingIndicator = Expanded(
          child: Center(child: CupertinoActivityIndicator(radius: 15.0)));
      sections.add(loadingIndicator);
    } else {
      final searchResults = Flexible(
        child: WordsWidget(_wordItems, emptyText: "No results.",));
      sections.add(searchResults);
    }

    return Column(children: sections);
  }

  Widget _buildSearchField(Configuration config) {
    return Expanded(
        child: Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder: config.toString(),
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => _lookup(config, q))));
  }

  void _lookup(Configuration config, String query) async {
    if (query.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _activeConfig = config;
      _selectedResult = null;
    });
    final results = await DictionaryService.instance.searchHeadwords(config, query);
    final items = results.map((r) {
      final word = Word(r.word, _activeConfig.from);
      return WordsWidget.translatableItem(word, () => _select(r));
    }).toList();
    setState(() {
      _isLoading = false;
      _wordItems = items;
    });
  }

  void _select(SearchResult result) async {
    setState(() {
      _isLoading = true;
      _selectedResult = result;
    });
    final word = Word(result.word, _activeConfig.from);
    final translations = await DictionaryService.instance.getTranslations(_activeConfig, result);
    final items = translations.map((t) {
      final translation = Word(t.text, _activeConfig.to);
      return WordsWidget.translatedItem(word, translation, _rebuild);
    }).toList();
    setState(() {
      _isLoading = false;
      _wordItems = items;
    });
  }

  void _rebuild() => setState(() {});
}
