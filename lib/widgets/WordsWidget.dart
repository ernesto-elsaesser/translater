import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';

typedef WordTapCallback = void Function(Word);

class WordItem {
  Word word;
  WidgetBuilder iconBuilder;
  WordTapCallback onTap;

  WordItem({this.word, this.iconBuilder, this.onTap});
}

class WordsWidget extends StatelessWidget {
  const WordsWidget(this.items, {Key key, this.emptyText = ""}) : super(key: key);

  final List<WordItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text(emptyText), heightFactor: 2);
    }

    return ListView.separated(
      itemBuilder: (_, int i) => _buildListItem(i, context),
      separatorBuilder: (_, __) =>
          Container(height: 1.0, color: CupertinoColors.lightBackgroundGray),
      itemCount: items.length,
    );
  }

  Widget _buildListItem(int i, BuildContext context) {
    final item = items[i];
    final itemStyle = TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500);
    final icon = item.iconBuilder(context);
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => item.onTap(item.word),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(children: [
              Expanded(child: Text(item.word.text, style: itemStyle)),
              icon
            ])));
  }

  static WordItem translatableItem(Word word, WordTapCallback onTap) {
    return WordItem(
        word: word,
        iconBuilder: (_) => Icon(CupertinoIcons.forward, color: CupertinoColors.lightBackgroundGray),
        onTap: onTap);
  }

  static WordItem translatedItem(Word word, Word translation, WordTapCallback onChange) {
    final vocabulary = VocabularyService.instance;
    final knownIcon = Icon(CupertinoIcons.minus_circled, color: CupertinoColors.destructiveRed);
    final unknownIcon = Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeGreen);

    WidgetBuilder iconBuilder = (_) => vocabulary.contains(translation) ? knownIcon : unknownIcon;

    WordTapCallback onTap = (_) {
      if (vocabulary.contains(word)) {
        vocabulary.unlearn(word, translation);
      } else {
        vocabulary.learn(word, translation);
      }
      onChange(word);
    };
    
    return WordItem(word: translation, iconBuilder: iconBuilder, onTap: onTap);
  }
}
