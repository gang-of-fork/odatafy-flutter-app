import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_template/detail/lineDetailView.dart';
import 'package:flutter_template/data/httpHelper.dart';

import '../data/property.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key, required this.data, required this.properties});
  final data;
  final List<Property> properties;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late HttpHelper httpHelper;
  Map<dynamic, TextEditingController> controllers = {};
  List<String> keys = [];
  List<Property> propertiesList = [];
  late Map<String, dynamic> valueMap = {};
  late Map<String, Type> typesMap = {};
  late Map<String, String> patternMap = {};
  late Map<String, int> maxLengthMap = {};
  bool fetching = true;

  @override
  void initState() {
    valueMap = widget.data;
    print(widget.data['products'].runtimeType);
    propertiesList = widget.properties;

    print(valueMap['products'].runtimeType);
    print(valueMap['products'][0]);

    print(propertiesList[0].name);

    keys = valueMap.keys.toList();

    valueMap.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });

    getPropertiesType(propertiesList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fetching
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 100, 20, 20),
                  child: Column(
                    children: [
                      for (int i = 0; i < keys.length; i++)
                        if (keys[i] == "_id")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              "ID: ${valueMap[keys[i]]}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          )
                        else
                          Column(
                            children: [
                              LineDetailView(
                                  controller: controllers[keys[i]],
                                  name: keys[i],
                                  type: typesMap[keys[i]]),
                              const SizedBox(height: 16),
                            ],
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 0),
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: () {
                                    checkInputOfTextField(controllers, typesMap,
                                        patternMap, maxLengthMap);
                                  },
                                  child: Text("Speichern")),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
  }

  getPropertiesType(List<Property> propertiesList) {
    Map<String, Type> dataTypeMap = {};
    List<Type> dataTypeList = [];
    propertiesList.forEach((property) {
      DataTypeEnum resultDataType = DataTypeEnum.noType;
      property.typesClass.forEach((typesClass) {
        resultDataType = getMoreRestrictiveType(
            resultDataType, transformFormatToDataType(typesClass.format));
      });

      if (resultDataType == DataTypeEnum.noType) {
        property.typesClass.forEach((typesClass) {
          resultDataType = getMoreRestrictiveType(
              resultDataType, transformTypesListToDataType(typesClass.types));
        });
      }
      dataTypeMap[property.name] = transformDataTypeToType(resultDataType);
      dataTypeList.add(transformDataTypeToType(resultDataType));
    });

    setState(() {
      fetching = false;
      typesMap = dataTypeMap;
    });
  }

  DataTypeEnum getMoreRestrictiveType(
      DataTypeEnum resultDataType, DataTypeEnum newDataType) {
    if (resultDataType.index < newDataType.index) {
      return newDataType;
    }
    return resultDataType;
  }

  DataTypeEnum transformFormatToDataType(String format) {
    switch (format) {
      case 'date-time':
        return DataTypeEnum.datetimeType;
      case 'double':
        return DataTypeEnum.doubleType;
      case 'decimal':
        return DataTypeEnum.doubleType;
      case 'int64':
        return DataTypeEnum.integerType;
      default:
        return DataTypeEnum.noType;
    }
  }

  DataTypeEnum transformTypesListToDataType(List<dynamic> types) {
    DataTypeEnum localResultDataType = DataTypeEnum.noType;
    types.forEach((type) {
      switch (type) {
        case 'boolean':
          localResultDataType = getMoreRestrictiveType(
              localResultDataType, DataTypeEnum.booleanType);
          break;
        case 'string':
          localResultDataType = getMoreRestrictiveType(
              localResultDataType, DataTypeEnum.stringType);
          break;
        case 'integer':
          localResultDataType = getMoreRestrictiveType(
              localResultDataType, DataTypeEnum.integerType);
          break;
        case 'number, string':
          localResultDataType = getMoreRestrictiveType(
              localResultDataType, DataTypeEnum.doubleType);
          break;
        case 'number [,string]':
          localResultDataType = getMoreRestrictiveType(
              localResultDataType, DataTypeEnum.doubleType);
          break;
        case 'array':
          localResultDataType =
              getMoreRestrictiveType(localResultDataType, DataTypeEnum.array);
          break;
        default:
          localResultDataType =
              getMoreRestrictiveType(localResultDataType, DataTypeEnum.noType);
          break;
      }
    });

    return localResultDataType;
  }

  Type transformDataTypeToType(DataTypeEnum dataType) {
    switch (dataType) {
      case DataTypeEnum.stringType:
        return String;
      case DataTypeEnum.integerType:
        return int;
      case DataTypeEnum.doubleType:
        return double;
      case DataTypeEnum.datetimeType:
        return DateTime;
      case DataTypeEnum.booleanType:
        return bool;
      case DataTypeEnum.array:
        return Array;
      default:
        return String;
      //throw ("No datatype found");
    }
  }

  void showInSnackbar(BuildContext context, String value) {
    // Shows a message to the user
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Text(value),
      ),
    );
  }

  createMaps(List<dynamic> propertiesList) {
    Map<String, String> localPatternMap = {};
    Map<String, int> localMaxLengthMap = {};
    propertiesList.forEach((oneProperty) {
      localPatternMap[oneProperty.name] = oneProperty.pattern;
      localMaxLengthMap[oneProperty.maxLength] = oneProperty.maxLength;
    });
    setState(() {
      patternMap = localPatternMap;
      maxLengthMap = localMaxLengthMap;
    });
  }

  checkInputOfTextField(
      Map<dynamic, TextEditingController> controllers,
      Map<String, Type> typesMap,
      Map<String, String> patternMap,
      Map<String, int> maxLengthMap) {
    bool noProblems = true;
    String snackBarText = "";
    controllers.forEach((key, controller) {
      switch (typesMap[key]) {
        case int:
          if (!isInputValidInt(controller.text, maxLengthMap[key])) {
            if (maxLengthMap[key] != null) {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]} and with a maximum length of ${maxLengthMap[key]}.';
            } else {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]}.';
            }
            noProblems = false;
          }
          break;
        case double:
          if (!isInputValidDouble(controller.text, maxLengthMap[key])) {
            if (maxLengthMap[key] != null) {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]} and with a maximum length of ${maxLengthMap[key]}.';
            } else {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]}.';
            }
            noProblems = false;
          }
          break;
        case String:
          if (!isInputValidString(controller.text, maxLengthMap[key])) {
            if (maxLengthMap[key] != null) {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]} and with a maximum length of ${maxLengthMap[key]}.';
            } else {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]}.';
            }
            noProblems = false;
          }
          break;
        case DateTime:
          if (!isInputValidDateTime(controller.text, maxLengthMap[key])) {
            if (maxLengthMap[key] != null) {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]} and with a maximum length of ${maxLengthMap[key]}.';
            } else {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]}.';
            }
            noProblems = false;
          }
          break;
        case bool:
          if (!isInputValidBoolean(controller.text, maxLengthMap[key])) {
            if (maxLengthMap[key] != null) {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]} and with a maximum length of ${maxLengthMap[key]}.';
            } else {
              snackBarText =
                  'In the field ${key} is an error. Input should be of type: ${typesMap[key]}.';
            }
            noProblems = false;
          }
          break;
      }
    });
    if (noProblems) {
      sendData(controllers);
    } else {
      showInSnackbar(context, snackBarText);
    }
  }

  bool isInputValidInt(String input, int? maxLength) {
    if (maxLength != null && input.length > maxLength) {
      return false;
    }
    return int.tryParse(input) != null;
  }

  bool isInputValidDouble(String input, int? maxLength) {
    if (maxLength != null && input.length > maxLength) {
      return false;
    }
    return double.tryParse(input) != null;
  }

  bool isInputValidString(String input, int? maxLength) {
    return maxLength == null || input.length <= maxLength;
  }

  bool isInputValidDateTime(String input, int? maxLength) {
    if (maxLength != null && input.length > maxLength) {
      return false;
    }
    try {
      DateTime.parse(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool isInputValidBoolean(String input, int? maxLength) {
    return maxLength == null ||
        input.length <= maxLength &&
            (input.toLowerCase() == 'true' || input.toLowerCase() == 'false');
  }

  dynamic convertToType(Type? type, dynamic value) {
    switch (type) {
      case String:
        return value.toString();
      case int:
        return int.parse(value.toString());
      case double:
        return double.parse(value.toString());
      case DateTime:
        return DateTime.parse(value.toString());
      case bool:
        return (value.toString().toLowerCase() == 'true');
      case Array:
        for (var item in value) {
          print('Arrraaaaaaaayyyyy: ${item}');
        }

        return null;
      /*
        List<dynamic> convertedList = [];
        for (var item in value) {
          convertedList.add(convertToType(item.runtimeType, item));
        }
        return convertedList; */
      default:
        return value;
    }
  }

  sendData(Map<dynamic, TextEditingController> controllers) {
    //TODO: Write method, that sends updated data to backend and gives message to user
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    valueMap.forEach((key, value) {
      valueMap[key] = convertToType(typesMap[key], controllers[key]?.text);
    });

    httpHelper.updateCategory(valueMap['_id'], valueMap);
  }
}

enum DataTypeEnum {
  noType,
  stringType,
  integerType,
  doubleType,
  datetimeType,
  booleanType,
  array
}

class Array {}
