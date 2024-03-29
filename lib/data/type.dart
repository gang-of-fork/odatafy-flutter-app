import 'package:collection/collection.dart';

class TypeFormat {
  late List<dynamic>? types;
  late String format;
  // List<String> failes at casting type but types is List<String>

  TypeFormat(this.types, this.format);

  TypeFormat.fromJSON(Map<String, dynamic> importMap) {
    types = [];
    importMap["type"]?.runtimeType == List
        ? types = importMap["type"]?.map((value) {
            return value.toString();
          }).toList()
        : types?.add(importMap["type"] ?? "");
    format = importMap["format"]?.toString() ?? "";
  }

  @override
  bool operator ==(Object other) {
    Function eq = const DeepCollectionEquality().equals;
    if (other is TypeFormat) {
      print(format);
      print(other.format);
      print(types.toString());
      print(other.types.toString());
      print(eq(types, other.types));
      print(format == other.format);
    }
    return identical(this, other) ||
        other is TypeFormat &&
            runtimeType == other.runtimeType &&
            eq(types, other.types) &&
            format == other.format;
  }

  @override
  int get hashCode => types.hashCode ^ format.hashCode;
}
