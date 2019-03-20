import 'package:flutter/cupertino.dart';

import '../services/ConfigurationService.dart';

class BilingualSearchField extends StatelessWidget {
  const BilingualSearchField(this.searchCallback);

  final Function(SearchDirection, String) searchCallback;

  @override
  Widget build(BuildContext context) {
    final source = ConfigurationService.sourceLanguage;
    final target = ConfigurationService.targetLanguage;
    return Container(
        padding: EdgeInsets.all(10.0),
        color: CupertinoColors.lightBackgroundGray,
        child: Row(children: <Widget>[
          _buildSearchField(source, target),
          SizedBox(width: 10.0),
          _buildSearchField(target, source)
        ]));
  }

  Widget _buildSearchField(Language from, Language to) {
    final direction = SearchDirection(from, to);
    return Expanded(child: Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder: "$direction",
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => searchCallback(direction, q))));
  }
}
