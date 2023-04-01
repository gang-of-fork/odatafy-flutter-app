import 'dart:convert';

import '../data/property.dart';
import 'package:test/test.dart';

void main() {
  group('Property', () {
    test('Property with single type', () {
      final property = Property.fromJSON(jsonDecode(''' 
        {"name": {
          "type": "string"
        }}
      '''));
      expect(property.name, "name");
      expect(property.types, ["string"]);
      expect(property.ref, "");
      expect(property.maxLength, 0);
      expect(property.pattern, "");
      expect(property.itemTypes, []);
      expect(property.itemRef, "");
    });

    test('Property with multiple types', () {
      final property = Property.fromJSON(jsonDecode(''' 
      {"sku": {
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
        }}
      '''));

      expect(property.name, "sku");
      expect(property.types, ["decimal", "double", "int64"]);
      expect(property.ref, "");
      expect(property.maxLength, 0);
      expect(property.pattern, "");
      expect(property.itemTypes, []);
      expect(property.itemRef, "");
    });

    test('Property with array type', () {
      final property = Property.fromJSON(jsonDecode('''
      {"tags": {
        "type": "array",
        "items": {
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
      }}
 '''));

      expect(property.name, "tags");
      expect(property.types, ["array"]);
      expect(property.ref, "");
      expect(property.maxLength, 0);
      expect(property.pattern, "");
      expect(property.itemTypes, ["decimal", "double", "int64"]);
      expect(property.itemRef, "");
    });

    test('Property with maxLength and pattern', () {
      final property = Property.fromJSON(jsonDecode('''{"_id": {
"type": "string",
"maxlength": 24,
"pattern": "^[0-9a-fA-F]{24}\$"
}} '''));

      expect(property.name, "_id");
      expect(property.types, ["string"]);
      expect(property.ref, "");
      expect(property.maxLength, 24);
      expect(property.pattern, "^[0-9a-fA-F]{24}\$");
      expect(property.itemTypes, []);
      expect(property.itemRef, "");
    });

    test('Property with ref and type array', () {
      final property = Property.fromJSON(jsonDecode(''' 
      {"products": {
"type": "array",
"items": {
"anyOf": [
{
"\$ref": "#/definitions/Product"
},
{
"type": "null"
}
],
"relationships": {
"partner": "Order"
}
}
}}
      '''));

      expect(property.name, "products");
      expect(property.types, ["array"]);
      expect(property.ref, "");
      expect(property.maxLength, 0);
      expect(property.pattern, "");
      expect(property.itemTypes, ["null"]);
      expect(property.itemRef, "#/definitions/Product");
    });

    test('Property with ref and without type array', () {
      final property = Property.fromJSON(jsonDecode(''' 
      {"category": {
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
}}
      '''));

      expect(property.name, "category");
      expect(property.types, ["null"]);
      expect(property.ref, "#/definitions/Category");
      expect(property.maxLength, 0);
      expect(property.pattern, "");
      expect(property.itemTypes, []);
      expect(property.itemRef, "");
    });
  });
}
