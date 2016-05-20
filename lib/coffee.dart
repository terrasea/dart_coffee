library flyweight.coffee;

import 'package:reflectable/reflectable.dart';

class IsCoffee extends Reflectable {
    const IsCoffee();
}

abstract class Coffee {
  String get id;
  String get name;
  double get price;

  static Map _cache = {};
  static Map get cache => _cache;
  Coffee();
  factory Coffee.get(String name) => _cache.putIfAbsent(name, () => _findCoffee(name));

  static Coffee _findCoffee(String name) {
    const coffee = const IsCoffee();
    Map coffees = coffee.annotatedClasses.fold({}, (memo, c) => memo..[c.simpleName] = c);

    var className = name.replaceAll(' ', '');

    return coffees.containsKey(className) ? coffees[className].newInstance('', []) : new FakeCoffee();
  }
}

class FakeCoffee implements Coffee {
  String get id => "FakeCoffee";
  String get name => 'Unknown Coffee';
  double get price => 0.0;
}

@IsCoffee()
class Espresso implements Coffee {
  String get id => "Espresso";
  String get name => 'Espresso';
  double get price => 2.5;
}