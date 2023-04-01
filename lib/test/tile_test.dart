import 'dart:convert';

import '../data/tile.dart';
import 'package:test/test.dart';

void main() {
  group('Tile', () {
    test('Tile with five properties', () {
      final tile = Tile.fromJSON(jsonDecode(''' 
        {"Product": {
"type": "object",
"keys": [
"_id"
],
"properties": {
"name": {
"type": "string"
},
"description": {
"type": "string"
},
"category": {
"anyOf": [
{
"\$ref": "#/definitions/Category"
},
{
"type": "null"
}
],
"relationships": {
"partner": "Product"
}
},
"price": {
"anyOf": [
{
"type": [
"string",
"number"
],
"format": "decimal"
},
{
"type": [
"number",
"string"
],
"format": "double"
},
{
"type": [
"integer",
"integer"
],
"format": "int64"
}
]
},
"_id": {
"type": "string",
"maxlength": 24,
"pattern": "^[0-9a-fA-F]{24}\$"
},
"__v": {
"anyOf": [
{
"type": [
"string",
"number"
],
"format": "decimal"
},
{
"type": [
"number",
"string"
],
"format": "double"
},
{
"type": [
"integer",
"integer"
],
"format": "int64"
}
]
}
}
}}
      '''));
      expect(tile.name, "Product");
      expect(tile.type, "object");
      expect(tile.keys, ["_id"]);
      expect(tile.properties.length, 6);
    });
  });
}
