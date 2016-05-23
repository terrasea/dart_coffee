library flyweight.client;

import 'dart:html';
import 'dart:async' show Future;

import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import "package:web_socket_channel/html.dart";

import 'package:flyweight/coffee.dart';

var client;

Future<Coffee> getCoffee(className) async {
  var json = {};
  return await Coffee.getCoffeeFromJson(json);
}

main() async {

  Uri observatoryURL = Uri.parse('ws://localhost:4321');
  var socket = new HtmlWebSocketChannel.connect(observatoryURL);
  client = new json_rpc.Client(socket)
    ..listen()
    ;

  Coffee.setInitHandler(getCoffee);

  querySelector('#get-random').onClick.listen((e) async {
    print('get-random');
    Coffee coffee = await Coffee.getCoffee('Flat White');
  });
}


Future outputAnswer(answer) async {
  print(answer.runtimeType);

//  querySelector('#content').appendHtml('<div>${coffee.name}: ${coffee.price}</div>');
}

Future<Coffee> clientHandler(className) async {
  if(className is Map) {

        var id = className['id'];
        var name = className['name'];
        var price = className['price'];

  }

  return klass;
}