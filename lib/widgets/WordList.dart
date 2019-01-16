import 'package:flutter/cupertino.dart';

import 'ListItem.dart';
import 'ListHeader.dart';
import 'ListSeparator.dart';

typedef BoolCallback = bool Function();

class WordList extends StatelessWidget {
  const WordList(this.items, {Key key, this.emptyText = ""}) : super(key: key);

  final List<WordItem> items;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text(emptyText), heightFactor: 2);
    }

    return ListView.separated(
      itemBuilder: (_, int i) => items[i].buildWidget(),
      separatorBuilder: (_, __) => ListSeparator(),
      itemCount: items.length,
    );
  }
}

abstract class WordItem {
  Widget buildWidget();
}

class HeaderItem implements WordItem {
  String text;

  HeaderItem({this.text});

  Widget buildWidget() {
    return ListHeader(text: text);
  }
}

class AddableItem implements WordItem {
  static final plusIcon = Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeGreen);
  static final minusIcon = Icon(CupertinoIcons.minus_circled, color: CupertinoColors.destructiveRed);
  
  String text;
  BoolCallback isAdded;
  VoidCallback onTap;

  AddableItem({this.text, this.isAdded, this.onTap});

  Widget buildWidget() {
    return ListItem(
      text: text, 
      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500), 
      icon: isAdded() ? minusIcon : plusIcon, 
      onTap: onTap);
  }
}