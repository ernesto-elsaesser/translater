import 'package:flutter/cupertino.dart';

import '../services/ConfigurationService.dart';

class SearchField extends StatelessWidget {
  const SearchField(this.searchCallback);

  final Function(String) searchCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        color: CupertinoColors.lightBackgroundGray,
        child: _buildSearchField());
  }

  Widget _buildSearchField() {
    return Container(
            color: CupertinoColors.white,
            child: CupertinoTextField(
                placeholder: "Search for translations",
                decoration: null,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                padding: EdgeInsets.all(10.0),
                onSubmitted: (q) => searchCallback(q)));
  }
}
