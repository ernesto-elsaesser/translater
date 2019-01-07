import 'dart:ui' as ui show window;
import 'package:flutter/cupertino.dart';

import '../widgets/SearchWidget.dart';
import '../widgets/VocabularyWidget.dart';
import '../services/VocabularyService.dart';

class Tab {
  String title;
  IconData icon;
  WidgetBuilder builder;

  Tab(this.title, this.icon, this.builder);
}

class TranslaterApp extends StatefulWidget {
  @override
  TranslaterAppState createState() => new TranslaterAppState();
}

class TranslaterAppState extends State<TranslaterApp> {

  List<Tab> _tabs;

  @override
  void initState() {
    _tabs = [
      Tab('Translate', CupertinoIcons.search, (_) => SearchWidget()),
      Tab('Vocabulary', CupertinoIcons.book, (_) => VocabularyWidget()),
      Tab('Metrics', CupertinoIcons.eye, (_) => Container())
    ];
    super.initState();
    VocabularyService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Translater',
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
        builder: _pageBuilder(index));
  }

  WidgetBuilder _pageBuilder(int index) {
    final tab = _tabs[index];
    return (context) {
      final rootWidget = tab.builder(context);
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(top: true, bottom: true, child: rootWidget));
    };
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
