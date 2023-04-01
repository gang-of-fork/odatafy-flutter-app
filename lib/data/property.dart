class Property {
  late String name, ref, pattern, itemRef;
  late List<dynamic> types;
  late int maxLength;
  late List<dynamic> itemTypes;
  // List<String> failes at casting type but types is List<String>

  Property(this.name, this.types, this.ref, this.maxLength, this.pattern,
      this.itemTypes, this.itemRef);

  Property.fromJSON(Map<String, dynamic> importMap) {
    print(importMap.toString());
    name = importMap.keys.first;
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
