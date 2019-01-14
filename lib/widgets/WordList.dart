import 'package:flutter/cupertino.dart';

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
      separatorBuilder: (_, __) =>
          Container(height: 1.0, color: CupertinoColors.lightBackgroundGray),
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
    return Container(
          color: Color(0xFFBBBBDD),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text(text, textAlign: TextAlign.center)
          )
    );
  }
}

class AddableItem implements WordItem {
  static final plusIcon = Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeGreen);
  static final minusIcon = Icon(CupertinoIcons.minus_circled, color: CupertinoColors.destructiveRed);
  static final textStyle = TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500);
  
  String text;
  BoolCallback isAdded;
  VoidCallback onTap;

  AddableItem({this.text, this.isAdded, this.onTap});

  Widget buildWidget() {
    final icon = isAdded() ? minusIcon : plusIcon;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(children: [
                Expanded(child: Text(text, style: textStyle)),
                icon
              ])));
  }
}