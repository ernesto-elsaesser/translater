import 'package:flutter/cupertino.dart';

import '../services/DictionaryService.dart';
import '../services/VocabularyService.dart';
import 'WordsWidget.dart';
import 'SelectionHeader.dart';
import 'SplitBox.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  
  bool _isLoading = false;
  Word _query;
  List<AddableItem> _translations;

  @override
  Widget build(BuildContext context) {
    final searchBar = SplitBox(
      _buildSearchField(Configuration.englishToGerman),
      _buildSearchField(Configuration.germanToEnglish)
    );

    List<Widget> sections = [searchBar];

    if (_query != null) {
      final selectionHeader = SelectionHeader(_query,
        onDismiss: _clear);
      sections.add(selectionHeader);
    }

    if (_isLoading) {
      final loadingIndicator = Expanded(
          child: Center(child: CupertinoActivityIndicator(radius: 15.0)));
      sections.add(loadingIndicator);
    } else if (_translations != null) {
      final searchResults = Flexible(
        child: WordsWidget(_translations, emptyText: "No results.",));
      sections.add(searchResults);
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
    });
    final word = Word(query, config.from);
    final results = await DictionaryService.instance.getTranslations(config, query);
    if (results == null) {
      setState(() {
        _isLoading = false;
        _query = null;
        _translations = [];
      });
    } else {
      final translations = results.map((t) {
        final translation = Word(t.text, config.to);
        return _makeItem(word, translation);
      }).toList();
      setState(() {
        _isLoading = false;
        _query = word;
        _translations = translations;
      });
    }
  }

  void _clear() {
    setState(() {
        _query = null;
        _translations = null;
      });
  }

  AddableItem _makeItem(Word word, Word translation) {
    final vocabulary = VocabularyService.instance;
    VoidCallback onTap = () {
      if (vocabulary.contains(word)) {
        vocabulary.unlearn(word, translation);
      } else {
        vocabulary.learn(word, translation);
      }
      setState(() {});
    };
    return AddableItem(
      text: translation.text, 
      isAdded: () => vocabulary.contains(translation),
      onTap: onTap);
  }
}
