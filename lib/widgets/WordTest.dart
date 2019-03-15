import 'package:flutter/cupertino.dart';

import '../model/VocabularyModel.dart';
import 'SectionedTab.dart';

class WordTest extends StatefulWidget {

  WordTest(this.relations, {@required this.onFinished});
  final List<WordRelation> relations;
  final Function(int) onFinished;

  @override
  WordTestState createState() => WordTestState(relations, onFinished);
}

class WordTestState extends State<WordTest> {

  WordTestState(this.relations, this.onFinished);
  final List<WordRelation> relations;
  final Function(int) onFinished;
  TextEditingController _textController = TextEditingController();
  int _index = 0;
  int _correctAnswers = 0;

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
    final inputForm = Row(children: <Widget>[
      Expanded(child: 
        CupertinoTextField(
          controller: _textController,
          decoration: BoxDecoration(border: Border.all()) ,
        )),
      CupertinoButton(
        child: Text("Next"), 
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
    final percentage = (_correctAnswers * 100) ~/ relations.length;
    final resultStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
    return [
      SizedBox(height: 30),
      Center(child: Text("Retention:")),
      SizedBox(height: 20),
      Text("$percentage %", style: resultStyle)
    ];
  }

  void _checkAndProceed() {
    final translation = relations[_index].translation.text;
    var correctDelta = _textController.text == translation ? 1 : 0;
    _textController.text = "";
    setState(() {
      _index += 1;
      _correctAnswers += correctDelta;
    });
  }
}