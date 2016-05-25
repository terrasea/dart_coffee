library flyweight.csv;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:csv/csv.dart';

class CoffeeListCSVParser {
  static Future<List> parse(String filename) async {
    final _csvCodec = new CsvCodec();
    var stream = new File(filename).openRead();
    return await stream
      .transform(UTF8.decoder)
      .transform(_csvCodec.decoder).toList();
  }
}
