library flyweight.csv;

import 'dart:io';

import 'package:csv/csv.dart';

class CoffeeListCSVParser {
  static Future<List> parse(String filename) async {
    final _csvCodec = new CsvCodec();
    return await new File(filename).openRead()
      .transform(UTF8.decoder)
      .transform(_csvCodec.decoder).toList();
  }
}
