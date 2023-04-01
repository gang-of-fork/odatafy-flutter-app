import 'package:flutter/material.dart';
import 'dart:convert';

class DetailView extends StatefulWidget {
  const DetailView({super.key, required this.data});
  final data;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Map<dynamic, TextEditingController> controllers = {};
  List<String> keys = [];
  Map<String, dynamic> valueMap = {};

  @override
  void initState() {
    valueMap = widget.data;
    print(widget.data);

    keys = valueMap.keys.toList();

    valueMap.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });

    print(keys);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool checked = true;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 100, 20, 20),
          child: Column(
            children: [
              for (dynamic key in keys)
                if (key == "_id")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "ID: ${valueMap[key]}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                else
                  Column(
                    children: [
                      TextField(
                        onChanged: (text) {
                          checkType(key, valueMap, controllers);
                        },
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: controllers[key],
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyLarge,
                          labelText: key,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
            ],
          )),
    );
  }
}

checkType(String key, Map<String, dynamic> valueMap,
    Map<dynamic, TextEditingController> controllers) {
  print(
      'ValueMap: ${valueMap} --- Key: ${key} --- Controllers: ${controllers} -- Controllers[Key]: ${controllers[key]}');
  Type type = valueMap[key].runtimeType;

  try {
    // Attempt to convert the value to the specified type
    final controller = controllers[key];

    // Use Dart's built-in type conversion functions to convert the value
    if (controller != null) {
      if (type == int) {
        valueMap[key] = int.tryParse(controller.text);
      } else if (type == double) {
        valueMap[key] = double.tryParse(controller.text);
      } else if (type == String) {
        valueMap[key] = controller.text;
      } else if (type == bool) {
        if (controller.text.toLowerCase() == 'true') {
          valueMap[key] = true;
        } else if (controller.text.toLowerCase() == 'false') {
          valueMap[key] = false;
        }
        print('Type: $type');
      } else {
        print('Unsupported type: $type');
        throw Exception('Unsupported type: $type');
      }
    }
    print("Right");

    // If the conversion was successful, return true
  } catch (e) {
    // If the conversion failed, return false
    print("Wrong");
  }
}
