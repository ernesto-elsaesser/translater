import 'package:flutter/cupertino.dart';

import 'Model.dart';
import 'DictionaryService.dart';
import 'ResultsWidget.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {

  DictionaryService _service = DictionaryService();
  bool _isLoading = false;
  List<ListItem> _listItems = [];
  Color _bgColor = const Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10.0),
          color: _bgColor,
          child: Row(children: <Widget>[
            _buildSearchField(Configuration.fromENtoDE),
            SizedBox(width: 10.0),
            _buildSearchField(Configuration.fromDEtoEN)
          ])),
      _buildResults()
    ]);
  }

  Widget _buildSearchField(Configuration config) {
    return Expanded(
        child: Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder:
                    '${config.from.toUpperCase()} > ${config.to.toUpperCase()}',
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => _lookup(config, q))));
  }

  Widget _buildResults() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 15.0)));
    }

    return ResultsWidget(
      items: _listItems, 
      tintColor: _bgColor);
  }

  void _lookup(Configuration config, String query) {
    setState(() {
      _isLoading = true;
    });
    _service.searchHeadwords(config, query).then((results) {
      final items = results.map((r) {
        return ListItem(r.word, () => _select(config, r));
      }).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }

  void _select(Configuration config, SearchResult result) {
    setState(() {
      _isLoading = true;
    });
    _service.getTranslations(config, result).then((translations) {
      final items = translations.map((t) {
        return ListItem(t.text, null);
      }).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }
}
