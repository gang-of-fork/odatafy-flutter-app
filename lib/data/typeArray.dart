import 'package:flutter_template/data/type.dart';

class TypeArray {
  late String itemRef;
  late List<dynamic> itemTypes;
  late TypeArray? typeArray;
  // max length, pattern,
  // List<String> failes at casting type but types is List<String>

  TypeArray(this.itemTypes, this.itemRef, this.typeArray);

  TypeArray.fromJSON(Map<String, dynamic> importMap) {
    itemTypes = [];
    importMap["items"]["anyOf"] != null
        ? itemTypes = importMap["items"]["anyOf"]
            .map((value) => TypeFormat.fromJSON(value))
            .toList()
        : itemTypes.add(TypeFormat.fromJSON(importMap["items"]));

    itemRef = importMap["items"]?["anyOf"]
            ?.map((value) {
              var test = value["\$ref"].toString();
              return test;
            })
            .toList()
            .firstWhere((element) => element != "null", orElse: () => "") ??
        "";
    typeArray = itemTypes.first.types.first.contains("array")
        ? TypeArray.fromJSON(importMap["items"]["anyOf"]["items"])
        : null;
  }
}
