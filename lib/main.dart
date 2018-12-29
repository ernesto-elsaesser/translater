import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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
  bool _isLoading = false;
  String result = "";

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    
    double spinnerOpacity = _isLoading ? 1.0 : 0.0;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          CupertinoTextField(
            controller: _textController, 
            placeholder: "DE > EN",
            autocorrect: false,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff333333),
                width: 1.0,
              ),
            ),
            onSubmitted: _translate),
            Opacity(
              opacity: spinnerOpacity, 
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CupertinoActivityIndicator()
              )
            ),
            Text(result)
        ])
    );
  }

  void _translate(String word) {

    String url = "https://od-api.oxforddictionaries.com:443/api/v1/entries/de/$word/translations=en";

    print(url);

    Map<String, String> headers =  {
      "Accept": "application/json",
      "app_id": "59a12a71",
      "app_key": "8d12fd6f89f0e8e76d6a039dbccf0bd0"
    };

    setState(() {  _isLoading = true; });

    http.get(url, headers: headers).then((res) { 
      setState(() {  
        _isLoading = false;
        result = res.body;
      });
    });
  }
}
