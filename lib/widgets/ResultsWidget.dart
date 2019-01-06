import 'package:flutter/cupertino.dart';

class ListItem {
  String title;
  WidgetBuilder iconBuilder;
  GestureTapCallback onTap;

  ListItem({this.title, this.iconBuilder, this.onTap});
}

class ResultsWidget extends StatelessWidget {
  const ResultsWidget(this.items, {Key key}) : super(key: key);

  final List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text("No results."), heightFactor: 2);
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
        onTap: item.onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(children: [
              Expanded(child: Text(item.title, style: itemStyle)),
              icon
            ])));
  }
}
