import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../services/VocabularyService.dart';
import 'SectionedTab.dart';

class CategoryMetric extends StatelessWidget {

  final Map<WordCategory, List<WordRelation>> categories;

  CategoryMetric() :
    categories = VocabularyService.instance.categorizedRelations(Language.english);

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [
      SizedBox(height: 50),
      Text("Category Distribution:"),
      SizedBox(height: 60),
      Center(child: SizedBox(height: 230, child: _buildChart()))
    ];
    return SectionedTab(sections);
  }

  Widget _buildChart() {
    final series = charts.Series<WordCategory, int>(
        id: 'Categories',
        domainFn: (WordCategory cat, _) => cat.index,
        measureFn: (WordCategory cat, _) => categories[cat].length,
        labelAccessorFn: (WordCategory cat, _) => WordCategories.name(cat),
        data: categories.keys.toList(),
      );
    final renderer = charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator( labelPosition: charts.ArcLabelPosition.outside)
        ]);
    return charts.PieChart([series], 
      animate: false,
      defaultRenderer: renderer);
  }
}