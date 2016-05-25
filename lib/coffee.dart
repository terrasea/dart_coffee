library flyweight.coffee;

import 'dart:async' show Future;

typedef Future<Coffee> CoffeeFetcher(className);

abstract class Coffee {
  int get id;
  void set id(val);
  String get name;
  void set name(val);
  double get price;
  void set price(val);

  static CoffeeFetcher _handler;

  static Map _cache = {};
  static Map get cache => _cache;

  Coffee();

  static getCoffee(name) async => _cache.putIfAbsent(name, () => _findCoffee(name));
  static getCoffeeFromJson(Map json) async {
    print('get coffee from json: ${json}');
    Coffee coffee = _findCoffeeFromJson(json);

    print(coffee);

    return coffee;
  }

  static Future<Coffee> _findCoffee(name) async {
    print('find coffee: ${Coffee._handler}');
    return await Coffee._handler(name);
  }

  static Future<Coffee> _findCoffeeFromJson(json) async {
    print('find coffee from json');
    var coffee = new _CoffeeInstance.fromJson(json);
    print(coffee.toJson());
    return coffee;
  }

  static void setInitHandler(handler) {
    _handler = handler;
  }

  toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

class FakeCoffee extends Coffee {
  int get id => -1;
  void set id(val) {}
  String get name => 'Unknown Coffee';
  void set name(val) {}
  double get price => 0.0;
  void set price(val) {}

  Future<Coffee> init() => new Future.value(this);
}


class _CoffeeInstance extends Coffee {
  String _className;
  int _id;
  String _name;
  double _price;

  int get id => _id;
  void set id(val) {
    _id = val;
  }
  String get name => _name;
  void set name(val) {
    _name = val;
  }
  double get price => _price;
  void set price(val) {
    _price = val;
  }

  _CoffeeInstance(this._className);
  _CoffeeInstance.fromJson(json) {
    print('created coffee from json 1');
    _id = json['id'];
    print('created coffee from json 2');
    _name = json['name'];
    print('created coffee from json 3');
    _price = json['price'];
    print('created coffee from json final');
  }
}
