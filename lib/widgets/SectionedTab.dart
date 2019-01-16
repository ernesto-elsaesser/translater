import 'package:flutter/cupertino.dart';

class SectionedTab extends StatelessWidget {

  final List<Widget> sections;

  SectionedTab(this.sections);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(previousPageTitle: "Back"),
        child: SafeArea(
          top: true, 
          bottom: true, 
          child: Column(
            children: sections
          )));
  }
}
