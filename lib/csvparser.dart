library flyweight.csv;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:csv/csv.dart';

class CoffeeListCSVParser {
  static Future<List> parse(String filename) async {
    print('parse ${filename}');
    final _csvCodec = new CsvCodec();
    print('parse 2');
    var stream = new File(filename).openRead();
    print('parse 3 ${stream}');
    return await stream.transform(UTF8.decoder)
      .transform(_csvCodec.decoder).toList();
  }
}
