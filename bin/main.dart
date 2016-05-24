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
  List rows = await CoffeeListCSVParser.parse('coffees.txt');
  print(rows);

  var row = rows.firstWhere((item) => item[1] == className, orElse: () => null );
  
  if(row != null) {
    var id = row[0].trim();
    var name = row[1].trim();
    var price = double.parse(row[2].trim());

    print('Not fake');
    return await Coffee.getCoffeeFromJson({'id': id, 'name': name, 'price': price});
  }
  print('Fake');
  return new Future.value(new FakeCoffee());
}
