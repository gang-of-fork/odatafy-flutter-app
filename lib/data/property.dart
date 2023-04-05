import 'package:flutter_template/data/type.dart';
import 'package:flutter_template/data/typeArray.dart';

class Property {
  late String name, ref, pattern, itemRef;
  late List<dynamic> typesClass;
  late List<dynamic> types;
  late int maxLength;
  late List<dynamic> itemTypes;
  late TypeArray typeArray;
  // List<String> failes at casting type but types is List<String>

  Property(this.name, this.types, this.ref, this.maxLength, this.pattern,
      this.typesClass, this.itemTypes, this.itemRef, this.typeArray);

  Property.fromJSON(Map<String, dynamic> importMap) {
    name = importMap.keys.first;
    typesClass = [];
    importMap[name]["anyOf"] != null
        ? typesClass = importMap[name]["anyOf"]
            .map((value) => Type.fromJSON(value))
            .toList()
        : typesClass.add(Type.fromJSON(importMap[name]));
    types = importMap[name]["anyOf"]
            ?.map((value) {
              var test = value["format"].toString();
              return test;
            })
            .toList()
            .toSet()
            .toList() ??
        [];
    var format = importMap[name]["name"];
    var type = importMap[name]["type"];
    if (type != null) {
      types.add(type.toString());
    }
    if (types.contains("array")) {
      typeArray = TypeArray.fromJSON(importMap[name]);
    }
    ref = importMap[name]["anyOf"]
            ?.map((value) => value["\$ref"]?.toString())
            .toList()
            .first ??
        "";
    itemTypes = importMap[name]["items"]?["anyOf"]
            ?.map((value) {
              var test = value["format"].toString();
              return test;
            })
            .toList()
            .toSet()
            .toList() ??
        [];
    itemRef = importMap[name]["items"]?["anyOf"]
            ?.map((value) {
              var test = value["\$ref"].toString();
              return test;
            })
            .toList()
            .firstWhere((element) => element != "null", orElse: () => "") ??
        "";
    pattern = importMap[name]["pattern"] ?? "";
    maxLength = importMap[name]["maxlength"] ?? 0;
  }
}
