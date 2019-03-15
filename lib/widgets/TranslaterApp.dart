import 'dart:ui' as ui show window;
import 'package:flutter/cupertino.dart';

import 'SearchTab.dart';
import 'VocabularyTab.dart';
import 'MetricsTab.dart';
import '../services/VocabularyService.dart';

class Tab {
  String title;
  IconData icon;
  WidgetBuilder build;

  Tab(this.title, this.icon, this.build);
}

class TranslaterApp extends StatefulWidget {
  @override
  TranslaterAppState createState() => TranslaterAppState();
}

class TranslaterAppState extends State<TranslaterApp> {

  List<Tab> _tabs;

  @override
  void initState() {
    _tabs = [
      Tab('Translate', CupertinoIcons.search, (_) => SearchTab()),
      Tab('Vocabulary', CupertinoIcons.book, (_) => VocabularyTab()),
      Tab('Metrics', CupertinoIcons.gear, (_) => MetricsTab())
    ];
    super.initState();
    VocabularyService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Translater',
        debugShowCheckedModeBanner: false,
        home: _normalizedText(CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                _buildBarItem(0),
                _buildBarItem(1),
                _buildBarItem(2)
              ],
            ),
            tabBuilder: _buildTab)));
  }

  BottomNavigationBarItem _buildBarItem(int index) {
    final tab = _tabs[index];
    return BottomNavigationBarItem(
      title: Text(tab.title), 
      icon: Icon(tab.icon));
  }

  CupertinoTabView _buildTab(BuildContext context, int index) {
    return CupertinoTabView(
        defaultTitle: 'Translater', 
        builder: _tabs[index].build);
  }

  Widget _normalizedText(Widget child) {
    final defaults = MediaQueryData.fromWindow(ui.window);
    final normalized = MediaQueryData(
      size: defaults.size,
      devicePixelRatio: defaults.devicePixelRatio,
      textScaleFactor: 1.0,
      padding: defaults.padding,
      viewInsets: defaults.viewInsets,
      alwaysUse24HourFormat: defaults.alwaysUse24HourFormat,
      accessibleNavigation: defaults.accessibleNavigation,
      invertColors: defaults.invertColors,
      disableAnimations: defaults.disableAnimations,
      boldText: false,
    );
    return MediaQuery(data: normalized, child: child);
  }
}
