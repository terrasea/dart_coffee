library flyweight.client;

import 'dart:html';
import 'dart:async' show Future;

import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import "package:web_socket_channel/html.dart";

import 'package:flyweight/coffee.dart';

var client;

getCoffee(className) async => 
  Coffee.getCoffeeFromJson(await client.sendRequest('get', [className]));

main() async {
  Uri observatoryURL = Uri.parse('ws://localhost:4321');
  var socket = new HtmlWebSocketChannel.connect(observatoryURL);
  client = new json_rpc.Client(socket)
    ..listen()
    ;

  Coffee.setInitHandler(getCoffee);

  querySelector('#get-random').onClick.listen((e) async {
    Coffee coffee = await Coffee.getCoffee('Flat White');
    outputAnswer(coffee);
  });
}


void outputAnswer(coffee) {
  var output = querySelector('#content')
		..appendHtml('<div>${coffee.name}: ${coffee.price}</div>');
}


