import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';

class GrowthMetric extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [
      SizedBox(height: 50),
      Text("Growth in the past 6 months:"),
      SizedBox(height: 50),
      SizedBox(height: 250, child: _buildChart())
    ];
    return SectionedTab(sections);
  }

  Widget _buildChart() {
    final series = charts.Series<int, DateTime>(
        id: 'Growth',
        domainFn: (int m, _) => _pastMonthsDate(m),
        measureFn: (int m, _) => VocabularyService.instance.translationCount(before: _pastMonthsDate(m)),
        data: [5, 4, 3, 2, 1, 0], // last 6 months
      );
    return charts.TimeSeriesChart([series], 
      animate: false);
  }

  DateTime _pastMonthsDate(int i) {
    final interval = Duration(days: 30 * i); // close enough ...
    return DateTime.now().subtract(interval);
  }
}