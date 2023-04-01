class TypeArray {
  late String itemRef;
  late List<dynamic> itemTypes;
  late TypeArray? typeArray;
  // List<String> failes at casting type but types is List<String>

  TypeArray(this.itemTypes, this.itemRef, this.typeArray);

  TypeArray.fromJSON(Map<String, dynamic> importMap) {
    itemTypes = importMap["items"]?["anyOf"]
            ?.map((value) {
              var test = value["format"].toString();
              return test;
            })
            .toList()
            .toSet()
            .toList() ??
        [];
    itemRef = importMap["items"]?["anyOf"]
            ?.map((value) {
              var test = value["\$ref"].toString();
              return test;
            })
            .toList()
            .firstWhere((element) => element != "null", orElse: () => "") ??
        "";
    typeArray = itemTypes.first == "array"
        ? TypeArray.fromJSON(importMap["items"]["anyOf"]["items"])
        : null;
  }
}
