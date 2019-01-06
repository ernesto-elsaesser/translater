import 'package:flutter/cupertino.dart';

import '../model/Configuration.dart';
import '../model/OxfordDictionaryModel.dart';
import '../services/DictionaryService.dart';
import '../services/VocabularyService.dart';
import 'ResultsWidget.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  
  bool _isLoading = false;
  List<ListItem> _listItems = [];
  SearchResult _selectedResult;
  Configuration _activeConfig;

  final Color bgColor = const Color(0xFFBBBBBB);

  @override
  Widget build(BuildContext context) {
    final searchBar = Container(
        padding: EdgeInsets.all(10.0),
        color: bgColor,
        child: Row(children: <Widget>[
          _buildSearchField(Configuration.fromENtoDE),
          SizedBox(width: 10.0),
          _buildSearchField(Configuration.fromDEtoEN)
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
      final searchResults = Flexible(child: ResultsWidget(_listItems));
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

  void _lookup(Configuration config, String query) {
    setState(() {
      _isLoading = true;
      _activeConfig = config;
      _selectedResult = null;
    });
    DictionaryService.instance.searchHeadwords(config, query).then((results) {
      final items = results.map((r) {
        return ListItem(
            title: r.word,
            iconBuilder: (_) => Icon(CupertinoIcons.forward, color: bgColor),
            onTap: () => _select(r));
      }).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }

  void _select(SearchResult result) {
    setState(() {
      _isLoading = true;
      _selectedResult = result;
    });
    DictionaryService.instance
        .getTranslations(_activeConfig, result)
        .then((translations) {
      final items = translations.map((t) {
        return ListItem(
            title: t.text,
            iconBuilder: (_) => _vocabularyIcon(t),
            onTap: () => _toggleVocabulary(t));
      }).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }

  void _toggleVocabulary(Translation trans) {
    final vocabulary = VocabularyService.instance;
    final known = vocabulary.contains(trans.text, trans.language);
    if (known) {
      vocabulary.unlearn(trans.text, trans.language);
    } else {
      vocabulary.learn(_selectedResult.word, trans.text, _activeConfig);
    }
    setState(() {}); // rebuild widget to update list icons
  }

  Icon _vocabularyIcon(Translation trans) {
    final known =
        VocabularyService.instance.contains(trans.text, trans.language);
    final data =
        known ? CupertinoIcons.add_circled_solid : CupertinoIcons.add_circled;
    return Icon(data, color: bgColor);
  }
}
