import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/home/widgets/tilesWidget.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as Badges;

import '../data/httpHelper.dart';
import '../data/tile.dart';

class FilterView extends StatefulWidget {
  FilterView(
      {super.key,
      required this.tile,
      this.filter = const [],
      required this.tileDefinition});
  final tile;
  final List<String> filter;
  final Tile tileDefinition;

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late List<String> filter;

  late String _operator;
  late String _filterWord;
  late String _filter;
  late TextEditingController filterController;
  @override
  void initState() {
    filter = widget.filter;
    _filter = widget.tileDefinition.properties.first.name;
    _operator = "=";
    _filterWord = "";
    filterController = TextEditingController(text: _filterWord);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarIcon(actions: [], withBackButton: false),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Filter",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Wrap(children: [
            for (var singleFilter in filter)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: (InputChip(
                  label: Text(singleFilter),
                  onSelected: ((value) => {}),
                  onDeleted: (() => {
                        setState(() {
                          filter.remove(singleFilter);
                        })
                      }),
                )),
              ),
          ]),
          Wrap(
            runSpacing: 10.0,
            children: [
              SizedBox(
                width: 100,
                child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration:
                        InputDecoration(contentPadding: EdgeInsets.all(0.0)),
                    dropdownColor: Theme.of(context).primaryColor,
                    value: _filter,
                    items: widget.tileDefinition.properties.map((value) {
                      return DropdownMenuItem(
                          value: value.name, child: Text(value.name));
                    }).toList(),
                    onChanged: ((value) {
                      setState(() {
                        _filter = value.toString();
                      });
                    })),
              ),
              SizedBox(
                width: 35,
                child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration:
                        InputDecoration(contentPadding: EdgeInsets.all(0.0)),
                    dropdownColor: Theme.of(context).primaryColor,
                    value: _operator,
                    items: const [
                      DropdownMenuItem(child: Text("="), value: "="),
                      DropdownMenuItem(child: Text("≠"), value: "≠"),
                      DropdownMenuItem(child: Text(">"), value: ">"),
                      DropdownMenuItem(child: Text("<"), value: "<"),
                      DropdownMenuItem(child: Text("≤"), value: "≤"),
                      DropdownMenuItem(child: Text("≥"), value: "≥"),
                    ],
                    onChanged: ((value) {
                      setState(() {
                        _operator = value.toString();
                      });
                    })),
              ),
              SizedBox(
                  width: 200,
                  child: TextField(
                    controller: filterController,
                    onChanged: ((value) {
                      value.toString().length <= 1 ? setState(() {}) : "";
                    }),
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: filterController.text != ""
                      ? Theme.of(context).elevatedButtonTheme.style
                      : ButtonStyle(
                          enableFeedback: false,
                          overlayColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () {
                    filterController.text != ""
                        ? setState(() {
                            filter.add(
                                "$_filter $_operator '${filterController.text}'");
                          })
                        : "";
                  },
                  child: const Text("Filter hinzufügen"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.filter);
                  },
                  child: const Text("Filter anwenden"),
                ),
              ),
            ],
          ),
        ])));
  }

  String translateOperator(String operator) {
    switch (operator) {
      case "=":
        return "eq";
      case "≠":
        return "ne";
      case "<":
        return "lt";
      case ">":
        return "gt";
      case "≥":
        return "ge";
      case "≤":
        return "le";
      default:
        return "";
    }
  }
}
