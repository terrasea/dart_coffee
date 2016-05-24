library flyweight.server;

import 'dart:io' as dart_io;
import 'dart:async' show Future;

import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;

import 'package:flyweight/coffee.dart';
import 'package:flyweight/csvparser.dart';

import "package:shelf/shelf_io.dart" as io;
import 'dart:io' show InternetAddress;
import "package:shelf_web_socket/shelf_web_socket.dart" show webSocketHandler;

main() async {
  io.serve(webSocketHandler((webSocketChannel) {
    var server = new json_rpc.Server(webSocketChannel);

    Coffee.setInitHandler(serverHandler);

    server
      ..registerMethod("get", (json_rpc.Parameters nameParams) async {
        var name = nameParams[0].asString;
        print(name);
        return await Coffee.getCoffee(name);
      })
      ..listen();
  }), InternetAddress.LOOPBACK_IP_V4, 4321 );
}


Future<Coffee> serverHandler(String className) async {
  print('parsing csv');
  var cwd = dart_io.Directory.current.path;
  print('parsing csv 2 ${cwd}');
  List rows = await CoffeeListCSVParser.parse('${cwd}/coffees.txt');
  print(rows);

  
  var row = rows.firstWhere((item) { print('$className: "${item[1].trim()}"'); return item[1].toString().contains(className); }, orElse: () => null );
  
  if(row != null) {
    var id = row[0];
    var name = row[1].trim();
    var price = row[2];

    print('Not fake');
    return await Coffee.getCoffeeFromJson({'id': id, 'name': name, 'price': price});
  }
  print('Fake');
  return new Future.value(new FakeCoffee());
}
