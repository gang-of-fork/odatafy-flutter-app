import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_template/appBar.dart';

import 'package:flutter_template/detail/lineDetailView.dart';
import 'package:flutter_template/data/httpHelper.dart';

import '../data/property.dart';
import '../table/tableView.dart';

class DetailView extends StatefulWidget {
  const DetailView(
      {super.key,
      required this.data,
      required this.properties,
      required this.tile,
      required this.subSet,
      required this.tiles,
      required this.tileDefinitions});
  final Map<String, dynamic> data;
  final List<Property> properties;
  final tile;
  final bool subSet;
  final tiles;
  final tileDefinitions;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  late HttpHelper httpHelper;
  Map<dynamic, TextEditingController> controllers = {};
  List<String> keys = [];
  List<Property> propertiesList = [];
  String tile = '';
  late Map<String, dynamic> valueMap = {};
  late Map<String, Type> typesMap = {};
  late Map<String, String> patternMap = {};
  late Map<String, int> maxLengthMap = {};
  late Map<String, Property> propertyMap = {};
  bool changed = false;
  bool fetching = true;

  @override
  void initState() {
    tile = widget.tile['url'];
    valueMap = widget.data;
    propertiesList = widget.properties;
    keys = valueMap.keys.toList();

    valueMap.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });

    getPropertiesType(propertiesList);

    createMaps(propertiesList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fetching
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBarIcon(
              actions: [],
              withBackButton: false,
            ),
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
                              Row(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                    ),
                                    child: LineDetailView(
                                      controller: controllers[keys[i]],
                                      name: keys[i],
                                      type: typesMap[keys[i]],
                                      data: valueMap,
                                      property: propertyMap[keys[i]],
                                      id: valueMap['_id'],
                                      tile: widget.tile,
                                      tiles: widget.tiles,
                                      tileDefinitions: widget.tileDefinitions,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                    child: Container(
                                        child: propertyMap[keys[i]]?.ref != ""
                                            ? IconButton(
                                                icon: const Icon(Icons.link),
                                                onPressed: () {
                                                  print(
                                                      'Hier ist ein REF: ${propertyMap[keys[i]]?.ref}');
                                                  navigateToRefTable(
                                                      propertyMap[keys[i]]?.ref,
                                                      valueMap[keys[i]]
                                                          .toString());
                                                },
                                              )
                                            : Container()),
                                  )
                                ],
                              ),
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
                                        patternMap, maxLengthMap, valueMap);
                                  },
                                  child: const Text("Speichern")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 0),
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, changed);
                                  },
                                  child: const Text(
                                    "Zurück zur Übersicht",
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
  }

  //Create a map with data types of properties
  getPropertiesType(List<Property> propertiesList) {
    Map<String, Type> dataTypeMap = {};

    propertiesList.forEach((property) {
      DataTypeEnum resultDataType = DataTypeEnum.noType;
      property.typesClass!.forEach((typesClass) {
        resultDataType = getMoreRestrictiveType(
            resultDataType, transformFormatToDataType(typesClass.format));
      });

      if (resultDataType == DataTypeEnum.noType) {
        property.typesClass!.forEach((typesClass) {
          resultDataType = getMoreRestrictiveType(
              resultDataType, transformTypesListToDataType(typesClass.types));
        });
      }

      dataTypeMap[property.name] = transformDataTypeToType(resultDataType);
    });

    setState(() {
      fetching = false;
      typesMap = dataTypeMap;
    });
  }

  //Compare two types and return the more specific type (example: double > int)
  DataTypeEnum getMoreRestrictiveType(
      DataTypeEnum resultDataType, DataTypeEnum newDataType) {
    if (resultDataType.index < newDataType.index) {
      return newDataType;
    }
    return resultDataType;
  }

  //take format and transform to a data type
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

  //take the list of types and transform them to one type
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

  //First distinguish the data type of a property and save it as a DataTypeEnum, because DataTypeEnum has a ranking
  //Now the DataTypeEnum needs to be transformed to a real data type
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

  //Create maps for the properties, the maximum length of each property and the pattern of each property
  createMaps(List<dynamic> propertiesList) {
    //TODO: Implement pattern
    Map<String, String> localPatternMap = {};
    Map<String, int> localMaxLengthMap = {};
    Map<String, Property> localPropertyMap = {};
    propertiesList.forEach((oneProperty) {
      localPatternMap[oneProperty.name] = oneProperty.pattern;
      localMaxLengthMap[oneProperty.name] = oneProperty.maxLength ?? 0;
      localPropertyMap[oneProperty.name] = oneProperty;
    });
    setState(() {
      propertyMap = localPropertyMap;
      //patternMap = localPatternMap;
      maxLengthMap = localMaxLengthMap;
    });
  }

  //check if there are any errors in the input fields (false type or longer then maximum length)
  //if there is an error, than show a snackbar
  checkInputOfTextField(
      Map<dynamic, TextEditingController> controllers,
      Map<String, Type> typesMap,
      Map<String, String> patternMap,
      Map<String, int> maxLengthMap,
      Map<String, dynamic> valueMap) {
    bool noProblems = true;
    String snackBarText = "";
    controllers.forEach((key, controller) {
      if (valueMap[key].toString() != controller.text) {
        switch (typesMap[key]) {
          case int:
            if (!isInputValidInt(controller.text, maxLengthMap[key])) {
              if (maxLengthMap[key] != null && maxLengthMap[key]! > 0) {
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
              if (maxLengthMap[key] != null && maxLengthMap[key]! > 0) {
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
              if (maxLengthMap[key] != null && maxLengthMap[key]! > 0) {
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
              if (maxLengthMap[key] != null && maxLengthMap[key]! > 0) {
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
              if (maxLengthMap[key] != null && maxLengthMap[key]! > 0) {
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
      }
    });
    if (noProblems) {
      sendData(controllers);
    } else {
      showInSnackbar(context, snackBarText);
    }
  }

  //Checking whether input is valid or not:
  bool isInputValidInt(String input, int? maxLength) {
    if (maxLength != null && maxLength != 0) {
      if (input.length > maxLength) {
        return false;
      }
    }
    return int.tryParse(input) != null;
  }

  //Checking whether input is valid or not:
  bool isInputValidDouble(String input, int? maxLength) {
    if (maxLength != null && maxLength != 0) {
      if (input.length > maxLength) {
        return false;
      }
    }
    return double.tryParse(input) != null;
  }

  //Checking whether input is valid or not:
  bool isInputValidString(String input, int? maxLength) {
    return maxLength == null || maxLength == 0 || input.length <= maxLength;
  }

  //Checking whether input is valid or not:
  bool isInputValidDateTime(String input, int? maxLength) {
    if (maxLength != null && maxLength != 0) {
      if (input.length > maxLength) {
        return false;
      }
    }
    try {
      DateTime.parse(input);
      return true;
    } catch (_) {
      return false;
    }
  }

  //Checking whether input is valid or not:
  bool isInputValidBoolean(String input, int? maxLength) {
    if (maxLength != null && maxLength != 0) {
      if (input.length > maxLength) {
        return false;
      }
    }
    return input.toLowerCase() == 'true' || input.toLowerCase() == 'false';
  }

  //Convert to type
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

  //send Data to backend
  sendData(Map<dynamic, TextEditingController> controllers) {
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    Map<String, dynamic> newValueMap = {};

    newValueMap['_id'] = valueMap['_id'];
    String tempId = valueMap["_id"];
    valueMap.remove('_id');

    if (widget.subSet) {
      newValueMap[
              deleteNumericIdentifierInArrayFieldNames(valueMap.keys.first)] =
          valuesOfAnArrayInOneList(controllers);
    } else {
      valueMap.forEach((key, value) {
        if (typesMap[key] != Array &&
            valueMap[key].toString() != controllers[key]?.text) {
          newValueMap[key] =
              convertToType(typesMap[key], controllers[key]?.text);
        }
      });
    }
    Map<String, dynamic> tempValueMap = {};
    tempValueMap['_id'] = tempId;

    valueMap.forEach((key, value) {
      tempValueMap[key] = value;
    });
    valueMap = tempValueMap;
    changed = true;
    httpHelper.updateCategory(tile, newValueMap['_id'], newValueMap);
  }

  //for arrays there is an numeric identifier added to the field name, which needs to be removed
  String deleteNumericIdentifierInArrayFieldNames(String text) {
    List<String> words = text.split(" ");
    if (words.length > 1) {
      words.removeLast();
      text = words.join(" ");
    }
    return text;
  }

  //create a list for the array
  List<dynamic> valuesOfAnArrayInOneList(
      Map<dynamic, TextEditingController> controllers) {
    List<dynamic> arrayEntries = [];
    valueMap.forEach((key, value) {
      arrayEntries.add(convertToType(typesMap[key], controllers[key]?.text));
    });
    return arrayEntries;
  }

  //show a text in the snackbar
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

  void navigateToRefTable(String? ref, String id) {
    String tileName = ref!.split("/").last;
    var refTile;
    List<String> filterNavigation = [];
    var tileDefinition;
    for (var tileObj in widget.tiles) {
      if (tileObj["name"] == tileName) {
        refTile = tileObj;
      }
    }
    for (var definition in widget.tileDefinitions) {
      if (definition.name == tileName) {
        tileDefinition = definition;
        var property;
        definition.properties.forEach((prop) {
          if (prop.name == definition.keys.first) {
            property = prop;
          }
        });
        var formattedId = "'$id'";
        if (property != null && property.pattern == "^[0-9a-fA-F]{24}\$") {
          formattedId = "cast('$id',ObjectId)";
        }
        filterNavigation.add("${definition.keys.first} = ${formattedId}");
        print(filterNavigation.first);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => TableView(
              tile: refTile,
              tileDefinition: tileDefinition,
              tileDefinitions: widget.tileDefinitions,
              tiles: widget.tiles,
              filter: filterNavigation)),
    );
  }
}

//a enum DataTypeEnum with all possible data types
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

//Navigator.pop(changed)
