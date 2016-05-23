library flyweight.server;

import 'dart:io' as dart_io;
import 'dart:async' show Future;

import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;

import 'package:flyweight/coffee.dart';

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
  String content = await new dart_io.File('coffees.txt').readAsString();

  var line = content.split('\n').firstWhere(
      (line) => line.toLowerCase().contains(className.toLowerCase())
  );

  if(line != null) {
    var row = line.split(',');
    if (row.length == 3) {
      var id = row[0].trim();
      var name = row[1].trim();
      var price = double.parse(row[2].trim());

      print('Not fake');
      return await Coffee.getCoffeeFromJson({'id': id, 'name': name, 'price': price});
    }
  }
  print('Fake');
  return new Future.value(new FakeCoffee());
}