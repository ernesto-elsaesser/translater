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
  final Color bgColor = const Color(0xFFBBBBBB);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10.0),
          color: bgColor,
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
    } else {
      return ResultsWidget(_listItems);
    }
  }

  void _lookup(Configuration config, String query) {
    setState(() {
      _isLoading = true;
    });
    DictionaryService.shared.searchHeadwords(config, query).then((results) {
      final items = results.map((r) {
        return ListItem(
          title: r.word, 
          iconBuilder: (_) => Icon(CupertinoIcons.forward, color: bgColor), 
          onTap: () => _select(config, r));
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
    DictionaryService.shared.getTranslations(config, result).then((translations) {
      final items = translations.map((t) {
        return ListItem(
          title: t.text, 
          iconBuilder: (_) => _vocabularyIcon(t), 
          onTap: () => _toggleVocabulary(config, result, t));
      }).toList();
      setState(() {
        _isLoading = false;
        _listItems = items;
      });
    });
  }

  void _toggleVocabulary(Configuration config, SearchResult result, Translation trans) {
    bool known = VocabularyService.shared.inVocabulary(trans.text, trans.language);
    if (known) {
      VocabularyService.shared.unlearn(trans.text, trans.language);
    } else {
      VocabularyService.shared.learn(result.word, trans.text, config);
    }
    setState(() {}); // rebuild widget to update list icons
  }

  Icon _vocabularyIcon(Translation trans) {
    bool known = VocabularyService.shared.inVocabulary(trans.text, trans.language);
    IconData data = known ? CupertinoIcons.add_circled_solid : CupertinoIcons.add_circled;
    return Icon(data, color: bgColor);
  }
}
