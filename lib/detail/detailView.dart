import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_template/detail/lineDetailView.dart';

import '../data/property.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key, required this.data, required this.properties});
  final data;
  final List<Property> properties;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Map<dynamic, TextEditingController> controllers = {};
  List<String> keys = [];
  Map<String, dynamic> valueMap = {};
  Type doubleType = double;
  Type intType = int;
  Type stringType = String;

  @override
  void initState() {
    valueMap = widget.data;
    print("HEEEEEEEEEEEEEEEEEEEELLLLLLO");
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
    Map<String, Type> type = {
      "_id": String,
      "name": String,
      "description": String,
      "category": String,
      "price": double,
      "__v": int
    };

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
                      LineDetailView(
                          controller: controllers[key],
                          name: key,
                          type: type[key]),
                      const SizedBox(height: 16),
                    ],
                  ),
            ],
          )),
    );
  }
}
