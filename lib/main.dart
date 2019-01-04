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
  DictionaryService _service;
  TextEditingController _textController;
  List<ListItem> _listItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _service = DictionaryService('en', 'de');
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final content = _isLoading ? _buildLoadingWidget() : _buildList();
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: CupertinoTextField(
              controller: _textController,
              placeholder: 'EN > DE',
              style: _contentStyle(),
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
              autofocus: true,
              padding: EdgeInsets.all(10.0),
              onSubmitted: _lookup)),
      Divider(height: 1.0),
      content
    ]);
  }

  void _lookup(String query) {
    setState(() { _isLoading = true; });
    _service.searchHeadwords(query).then((results) {
      final items = results.map( (r) => ListItem(r.word, () => _select(r)) ).toList();
      setState(() {  _isLoading = false; _listItems = items; });
    });
  }

  void _select(SearchResult result) {
    setState(() { _isLoading = true; });
    _service.getTranslations(result).then((translations) {
      final items = translations.map( (t) => ListItem(t.text, null) ).toList();
      setState(() {  _isLoading = false; _listItems = items; });
    });
  }

  Widget _buildList() {
    if (_listItems.isEmpty) {
      return Container();
    }

    return Flexible(child:
      ListView.separated(
        itemBuilder: (_, int i) => _buildListItem(i),
        separatorBuilder: (_, __) => Divider(height: 1.0),
        itemCount: _listItems.length,
      )
    );
  }

  Widget _buildListItem(int i) {
    ListItem item = _listItems[i];
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Text(item.title, style: _contentStyle())
      )
    );
  }

  Widget _buildLoadingWidget() {
    return Expanded(
        child: Center(
          child: CupertinoActivityIndicator(radius: 20.0)));
  }

  TextStyle _contentStyle() {
    return TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500);
  }
}
