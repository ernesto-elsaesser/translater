import 'dart:io';
import 'package:xml/xml.dart' as xml;

// This script is used to transform TEI (XML) file retrieved from 
// https://github.com/freedict/fd-dictionaries into a custom CSV format

IOSink outputSink;

void main(List<String> args) {
  final name = args[0];
  var teiFile = File('$name.tei');
  var csvFile = File('assets/$name.csv');
  outputSink = csvFile.openWrite(mode: FileMode.append);

  print("reading ...");
  teiFile.readAsString().then(parse);
}

void parse(String xmlString) {

  print("parsing XML ...");
  final teiDocument = xml.parse(xmlString);

  print("searching entries ...");
  final entries = teiDocument.findAllElements('entry');
  
  var count = 0;
  print("iterating entries ...");
  entries.forEach( (entry) {
    try {
      final word = getWord(entry);
      final translation = getTranslation(entry);
      outputSink.write("$word\t$translation\n");
    } catch (e) {
      print("exception: $e");
      return;
    }
    count++;
    if (count % 1000 == 0) {
      print("$count words written");
    }
  });
  print("$count words written in total");

  print("flushing file ...");
  outputSink.flush().then( (_) { 
    print("closing file ...");
    outputSink.close().then( (_) {
      print("done.");
    });
  });
}

String getWord(xml.XmlElement entry) {
    final form = entry.findElements('form').first;
    if (form == null) throw "no form";
    final orth = form.findElements('orth').first;
    if (orth == null) throw "no orth";
    return orth.text;
}

String getTranslation(xml.XmlElement entry) {
    final sense = entry.findElements('sense').first;
    if (sense == null) throw "no sense";
    final cit = sense.findElements('cit').first;
    if (cit == null) throw "no cit";
    final type = cit.getAttribute('type');
    if (type != 'trans') throw "wrong cit type: $type";
    final quote = cit.findElements('quote').first;
    if (quote == null) throw "no quote";
    return quote.text;
}