import 'package:flutter/cupertino.dart';

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';
import 'CategoryMetric.dart';
import 'ListItem.dart';
import 'ListSeparator.dart';

class Metric {
  String displayName;
  WidgetBuilder builder;

  Metric(this.displayName, this.builder);
}

class MetricsTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [_buildKeyIndicatorBox()];
    List<Metric> metrics = [
      Metric("Word categories", (_) => CategoryMetric())
    ];
    for (final m in metrics) {
      sections.add(ListSeparator());
      final menuItem = _buildMenuItem(m, context);
      sections.add(menuItem);
    }
      sections.add(ListSeparator());
    return SectionedTab(sections);
  }

  Widget _buildKeyIndicatorBox() {
    final numberStyle = TextStyle(fontSize: 40.0, fontWeight: FontWeight.w600);
    final subtitleStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300);
    final totalCount = VocabularyService.instance.translationCount().toString();
    final now = DateTime.now();
    final monthCount = VocabularyService.instance.translationCount(month: now).toString();
    List<Widget> lines =[
      SizedBox(height: 50),
      Text(totalCount, style: numberStyle),
      Text("words in total", style: subtitleStyle),
      SizedBox(height: 25),
      Text(monthCount, style: numberStyle),
      Text("words this month", style: subtitleStyle),
    ];
    return Expanded(child:
      Column(children: lines)
      );
  }

  Widget _buildMenuItem(Metric metric, BuildContext context) {
    final chevron = Icon(CupertinoIcons.right_chevron, color: CupertinoColors.lightBackgroundGray);
    final route = CupertinoPageRoute(
      title: metric.displayName, 
      builder: metric.builder);
    return ListItem(
      text: metric.displayName,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
      icon: chevron,
      padding: 20.0,
      onTap: () => Navigator.push(context, route)
    );
  }
}