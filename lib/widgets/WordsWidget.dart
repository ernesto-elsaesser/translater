import 'package:flutter/cupertino.dart';

typedef BoolCallback = bool Function();

class AddableItem {
  String text;
  BoolCallback isAdded;
  VoidCallback onTap;

  AddableItem({this.text, this.isAdded, this.onTap});
}

class WordsWidget extends StatelessWidget {
  const WordsWidget(this.items, {Key key, this.emptyText = ""}) : super(key: key);

  static final plusIcon = Icon(CupertinoIcons.add_circled, color: CupertinoColors.activeGreen);
  static final minusIcon = Icon(CupertinoIcons.minus_circled, color: CupertinoColors.destructiveRed);

  final List<AddableItem> items;
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
    final icon = item.isAdded() ? minusIcon : plusIcon;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: item.onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(children: [
                Expanded(child: Text(item.text, style: itemStyle)),
                icon
              ])));
  }
}
