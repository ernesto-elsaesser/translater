import 'package:flutter/cupertino.dart';

import '../model/LinguisticModel.dart';
import 'SectionedTab.dart';

class WordTest extends StatefulWidget {

  WordTest(this.relations);
  final List<WordRelation> relations;

  @override
  WordTestState createState() => WordTestState(relations);
}

class WordTestState extends State<WordTest> {

  WordTestState(this.relations);
  final List<WordRelation> relations;
  TextEditingController _textController = TextEditingController();
  int _index = 0;
  List<String> _wrongAnswers = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> sections;
    if (_index < relations.length) {
      sections = _buildTestForm();
    } else {
      sections = _buildResults();
    }
    return SectionedTab(sections);
  }

  List<Widget> _buildTestForm() {
    final word = relations[_index].word.text;
    final isLast = _index == relations.length - 1;
    final inputForm = Row(children: <Widget>[
      Expanded(child: 
        CupertinoTextField(
          controller: _textController,
          decoration: BoxDecoration(border: Border.all()) ,
        )),
      CupertinoButton(
        child: Text(isLast ? "Finish" : "Next"), 
        onPressed: _checkAndProceed)
    ]);
    return [
      SizedBox(height: 30),
      Text(word),
      SizedBox(height: 20),
      Padding(padding: EdgeInsets.all(10), child: inputForm)
    ];
  }

  List<Widget> _buildResults() {
    final correctAnswers = relations.length - _wrongAnswers.length;
    final percentage = (correctAnswers * 100) ~/ relations.length;
    final resultStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
    final wrongLines = _wrongAnswers.join('\n');
    final wrongStyle = TextStyle(fontSize: 16, color: CupertinoColors.destructiveRed);
    return [
      SizedBox(height: 30),
      Center(child: Text("Retention:")),
      SizedBox(height: 20),
      Text("$percentage %", style: resultStyle),
      SizedBox(height: 30),
      Center(child: Text("Wrong answers:")),
      SizedBox(height: 20),
      Text(wrongLines, style: wrongStyle)
    ];
  }

  void _checkAndProceed() {
    final relation = relations[_index];
    final question = relation.word.text;
    final givenAnswer = _textController.text;
    final correctAnswer = relation.translation.text;
    _textController.text = "";
    setState(() {
      _index += 1;
      if (givenAnswer != correctAnswer) {
        _wrongAnswers.add(question + ' - ' + correctAnswer + ' (' + givenAnswer + ')');
      }
    });
  }
}