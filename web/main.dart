library flyweight.client;

import 'dart:html';
import 'dart:async' show Future;

import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import "package:web_socket_channel/html.dart";

import 'package:flyweight/coffee.dart';

var client;

Future<Coffee> getCoffee(className) async {
  print('handler');
  var json = {};
  await client.sendRequest('get', [className]);
  return Coffee.getCoffeeFromJson(json);
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
    outputAnswer(coffee);
  });
}


void outputAnswer(coffee) {
  print(coffee.toJson());

  var output = querySelector('#content')
		..appendHtml('<div>${coffee.name}: ${coffee.price}</div>');
}


