import 'package:flutter/cupertino.dart';

import '../model/VocabularyModel.dart';

class BilingualSearchField extends StatelessWidget {
  const BilingualSearchField(
    this.left, 
    this.right, 
    {@required this.searchCallback});

  final Language left, right;
  final Function(Configuration,String) searchCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        color: CupertinoColors.lightBackgroundGray,
        child: Row(children: <Widget>[
          _buildSearchField(left, right),
          SizedBox(width: 10.0),
          _buildSearchField(right, left)
        ]));
  }

  Widget _buildSearchField(Language from, Language to) {
    final config = Configuration(from, to);
    return Expanded(child: Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder: config.toString(),
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => searchCallback(config, q))));
  }
}
