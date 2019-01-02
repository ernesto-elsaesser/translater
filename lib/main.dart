import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DictionaryService.dart';

void main() => runApp(TranslaterApp());

class TranslaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 21.0); // flutters default sizing is off
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

class SearchWidgetState extends State<SearchWidget> {
  DictionaryService _service;
  TextEditingController _textController;
  List<Entry> _entries = [];
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
              clearButtonMode: OverlayVisibilityMode.editing,
              autocorrect: false,
              autofocus: true,
              padding: EdgeInsets.all(5.0),
              onSubmitted: _lookup)),
      Divider(height: 1.0),
      content
    ]);
  }

  void _lookup(String query) {
    setState(() {
      _isLoading = true;
    });

    _service.getEntries(query).then((entries) {
      if (entries.length == 1) {
        _select(entries.first);
      } else {
        setState(() {
          _isLoading = false;
          _entries = entries;
        });
      }
    });
  }

  void _select(Entry entry) {
    setState(() {
      _isLoading = true;
    });

    _service.getTranslations(entry).then((translations) {
      setState(() {
        _isLoading = false;
        _entries = translations;
      });
    });
  }

  Widget _buildList() {
    if (_entries.isEmpty) {
      return Placeholder();
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      itemBuilder: (_, int index) => _buildListEntry(index),
      separatorBuilder: (_, _alreadydefinedwtf) => Divider(height: 1.0),
      itemCount: _entries.length,
    );
  }

  Widget _buildListEntry(int index) {
    Entry entry = _entries[index];
    return Text(entry.word);
  }

  Widget _buildLoadingWidget() {
    return Expanded(
        child: Container(
            child: Center(child: CupertinoActivityIndicator()),
            color: Colors.black.withAlpha(100)));
  }
}
