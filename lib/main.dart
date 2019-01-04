import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model.dart';
import 'DictionaryService.dart';

void main() => runApp(TranslaterApp());

class TranslaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 21.0);
    return CupertinoApp(
        title: 'Translater',
        home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: Text('Translater', style: titleStyle)),
            child: SafeArea(top: true, bottom: false, child: SearchWidget())));
  }
}

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class ListItem {
  String title;
  GestureTapCallback onTap;

  ListItem(this.title, this.onTap);
}

class SearchWidgetState extends State<SearchWidget> {
  DictionaryService _service = DictionaryService();
  Configuration _confENtoDE = Configuration(Languages.en, Languages.de);
  Configuration _confDEtoEN = Configuration(Languages.de, Languages.en);
  List<ListItem> _listItems = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final content = _isLoading ? _buildLoadingWidget() : _buildList();
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.black.withAlpha(50),
          child: Row(children: <Widget>[
            _buildSearchField(_confENtoDE),
            SizedBox(width: 10.0),
            _buildSearchField(_confDEtoEN)
          ])),
      content
    ]);
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
      final items = translations.map((t) => ListItem(t.text, null)).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }

  Widget _buildSearchField(Configuration config) {
    return Expanded(child: Container(
      color: CupertinoColors.white,
      child: CupertinoTextField(
        placeholder: '${config.from.toUpperCase()} > ${config.to.toUpperCase()}',
        style: _contentStyle(),
        decoration: null,
        clearButtonMode: OverlayVisibilityMode.editing,
        autocorrect: false,
        padding: EdgeInsets.all(10.0),
        onSubmitted: (q) => _lookup(config, q)
        )
      )
    );
  }

  Widget _buildList() {
    if (_listItems.isEmpty) {
      return Container();
    }

    return Flexible(
        child: ListView.separated(
      itemBuilder: (_, int i) => _buildListItem(i),
      separatorBuilder: (_, __) => Divider(height: 1.0),
      itemCount: _listItems.length,
    ));
  }

  Widget _buildListItem(int i) {
    ListItem item = _listItems[i];
    return GestureDetector(
        onTap: item.onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Text(item.title, style: _contentStyle())));
  }

  Widget _buildLoadingWidget() {
    return Expanded(
        child: Center(child: CupertinoActivityIndicator(radius: 15.0)));
  }

  TextStyle _contentStyle() {
    return TextStyle(
        color: CupertinoColors.black,
        fontFamily: '.SF Pro Text',
        fontSize: 18.0,
        fontWeight: FontWeight.w500);
  }
}
