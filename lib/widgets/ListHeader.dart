import 'package:flutter/cupertino.dart';

class ListHeader extends StatelessWidget {

  final String text;
  final double padding;

  ListHeader({@required this.text, this.padding = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
          color: Color(0xFFBBBBDD),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(text) //  textAlign: TextAlign.center
          )
    );
  }
}
