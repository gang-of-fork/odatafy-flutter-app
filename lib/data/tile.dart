import 'package:flutter_template/data/property.dart';
import 'dart:convert';

class Tile {
  late String name, type;
  late List<dynamic> keys;
  late List<Property> properties;

  Tile(this.name, this.type, this.keys, this.properties);

  Tile.fromJSON(Map<String, dynamic> importMap) {
    name = importMap.keys.first;
    type = importMap[name]["type"] ?? [];
    keys = importMap[name]["keys"]?.map((value) => value.toString()).toList() ??
        [];
    properties = [];
    importMap[name]["properties"].keys.forEach((value) {
      var json = '{"' +
          value +
          '":' +
          jsonEncode(importMap[name]["properties"][value]) +
          "}";
      properties.add(Property.fromJSON(jsonDecode(json)));
    });
  }
}
