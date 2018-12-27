import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(TranslaterApp());

class TranslaterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Translater',
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('Translater')),
        child: SafeArea(top: true, bottom: false, child: SearchWidget())
      )
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => new SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {

  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: CupertinoTextField(
        controller: _textController, 
        placeholder: 'DE > EN',
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff333333),
            width: 1.0,
          ),
        ),
        onSubmitted: _translate)
    );
  }

  void _translate(String query) {
    // TODO: send request to translation API, present results
    print(query);
  }
}
