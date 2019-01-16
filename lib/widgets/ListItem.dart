import 'package:flutter/cupertino.dart';

class ListItem extends StatelessWidget {

  final String text;
  final TextStyle style;
  final double padding;
  final Icon icon;
  final VoidCallback onTap;

  ListItem({@required this.text, this.style, this.padding = 10.0,this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(text, style: style);
    Widget content;
    if (icon == null) {
      content = textWidget;
    } else {
      content = Row(children: [
                Expanded(child: Text(text, style: style)),
                icon
              ]);
    }
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.all(padding),
            child: content));
  }
}






