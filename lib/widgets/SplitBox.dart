import 'package:flutter/cupertino.dart';

class SplitBox extends StatelessWidget {
  const SplitBox(this.left, this.right, {Key key}) : super(key: key);

  final Widget left, right;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        color: CupertinoColors.lightBackgroundGray,
        child: Row(children: <Widget>[
          Expanded(child: left),
          SizedBox(width: 10.0),
          Expanded(child: right)
        ]));
  }
}
