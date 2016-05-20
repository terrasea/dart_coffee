library flyweight.coffee;

import 'dart:io';

import 'package:reflectable/reflectable.dart';

class IsCoffee extends Reflectable {
    const IsCoffee() : super(newInstanceCapability, subtypeQuantifyCapability);
}

abstract class Coffee {
  String get id;
  String get name;
  double get price;

  static Map _cache = {};
  static Map get cache => _cache;

  Coffee();

  static Coffee getCoffee(String name) async => _cache.putIfAbsent(name, () => _findCoffee(name));

  static Coffee _findCoffee(String name) async {
    var coffee = new _CoffeeInstance(name);
    await coffee.init();

    return coffee;
  }
}

class FakeCoffee implements Coffee {
  String get id => "FakeCoffee";
  String get name => 'Unknown Coffee';
  double get price => 0.0;
}

@IsCoffee()
class Espresso implements Coffee {
  Espresso();

  String get id => "Espresso";
  String get name => 'Espresso';
  double get price => 2.5;
}


class _CoffeeInstance implements Coffee {
  String _className;
  String _id;
  String _name;
  double _price;

  String get id => _id;
  String get name => _name;
  double get price => _price;

  _CoffeeInstance(this._className);

  init() async {
    String content = await new File('coffees.txt').readAsString();
    var lines = content.split('\n')
        ..firstWhere((line) => line.toLowerCase().contains(_className.toLowerCase()));
    var line = lines.first;

    if(line != null) line = line.split(',');
    if(line.length == 3) {
        _id = line[0].trim();
        _name = line[1].trim();
        _price = double.parse(line[2].trim());
    }

    return line;
  }
}