import 'package:flutter_template/data/type.dart';
import 'package:flutter_template/data/typeArray.dart';

class Property {
  late String name, pattern;
  late String? ref, itemRef;
  late List<dynamic>? typesClass;
  late List<dynamic> types;
  late int? maxLength;
  late List<dynamic>? itemTypes;
  TypeArray? typeArray;
  late List<dynamic> keys;
  // List<String> failes at casting type but types is List<String>

  Property(this.name, this.types, this.ref, this.maxLength, this.pattern,
      this.typesClass, this.itemTypes, this.itemRef, this.typeArray, this.keys);

  Property.fromJSON(Map<String, dynamic> importMap) {
    name = importMap.keys.first;
    typesClass = [];
    importMap[name]["anyOf"] != null
        ? typesClass = importMap[name]["anyOf"]
            .map((value) => TypeFormat.fromJSON(value))
            .toList()
        : typesClass!.add(TypeFormat.fromJSON(importMap[name]));
    keys = importMap[name]["keys"] ?? [];
    types = importMap[name]["anyOf"]
            ?.map((value) {
              var test = value["format"].toString();
              return test;
            })
            .toList()
            .toSet()
            .toList() ??
        [];
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
