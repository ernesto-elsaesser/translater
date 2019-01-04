import 'package:flutter/cupertino.dart';

class ListItem {
  String title;
  GestureTapCallback onTap;

  ListItem(this.title, this.onTap);
}

class ResultsWidget extends StatelessWidget {

  const ResultsWidget({Key key, this.items, this.tintColor}): super(key: key);

  final List<ListItem> items;
  final Color tintColor;

  @override
  Widget build(BuildContext context) {

    if (items.isEmpty) {
      return Container();
    }

    return Flexible(
        child: ListView.separated(
      itemBuilder: (_, int i) => _buildListItem(i),
      separatorBuilder: (_, __) => Container(height: 1.0, color: tintColor),
      itemCount: items.length,
    ));
  }

  Widget _buildListItem(int i) {
    ListItem item = items[i];
    Color chevronColor = item.onTap == null ? CupertinoColors.white : tintColor;
    TextStyle itemStyle = TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500);
    return GestureDetector(
        onTap: item.onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(children: <Widget>[
              Expanded(child: Text(item.title, style: itemStyle)),
              Icon(CupertinoIcons.forward, color: chevronColor)
            ])));
  }
}
