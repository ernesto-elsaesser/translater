import 'package:flutter/cupertino.dart';

import '../services/DictionaryService.dart';
import 'WordsWidget.dart';
import 'SelectionHeader.dart';
import 'SplitBox.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  
  bool _isLoading = false;
  Configuration _activeConfig;
  List<WordItem> _searchResults;
  Word _selectedWord;
  List<WordItem> _translationResults;

  @override
  Widget build(BuildContext context) {
    final searchBar = SplitBox(
      _buildSearchField(Configuration.englishToGerman),
      _buildSearchField(Configuration.germanToEnglish)
    );

    List<Widget> sections = [searchBar];

    if (_selectedWord != null) {
      final selectionHeader = SelectionHeader(_selectedWord,
        onDismiss: _unselect);
      sections.add(selectionHeader);
    }

    if (_isLoading) {
      final loadingIndicator = Expanded(
          child: Center(child: CupertinoActivityIndicator(radius: 15.0)));
      sections.add(loadingIndicator);
    } else {
      final items = _translationResults ?? _searchResults;
      if (items != null) {
        final searchResults = Flexible(
          child: WordsWidget(items, emptyText: "No results.",));
        sections.add(searchResults);
      }
    }

    return Column(children: sections);
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

  void _lookup(Configuration config, String query) async {
    if (query.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _selectedWord = null;
      _translationResults = null;
    });
    final results = await DictionaryService.instance.searchHeadwords(config, query);
    final items = results.map((r) {
      final word = Word(r.word, config.from);
      return WordsWidget.translatableItem(word, _select);
    }).toList();
    setState(() {
      _isLoading = false;
      _activeConfig = config;
      _searchResults = items;
    });
  }

  void _select(Word word) async {
    setState(() {
      _isLoading = true;
    });
    final translations = await DictionaryService.instance.getTranslations(_activeConfig, word.text);
    final items = translations.map((t) {
      final translation = Word(t.text, _activeConfig.to);
      return WordsWidget.translatedItem(word, translation, _rebuild);
    }).toList();
    setState(() {
      _isLoading = false;
      _selectedWord = word;
      _translationResults = items;
    });
  }

  void _unselect() {
    setState(() {
      _selectedWord = null;
      _translationResults = null;
    });
  }

  void _rebuild(Word word) => setState(() {});
}
