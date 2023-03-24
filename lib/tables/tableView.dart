import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/tiles/tilesWidget.dart';
import 'package:collection/collection.dart';

import '../data/httpHelper.dart';

class TableView extends StatefulWidget {
  const TableView({super.key, required this.tile});
  final tile;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  bool fetching = true;

  late HttpHelper httpHelper;

  List<String> columns = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarIcon(actions: []),
        backgroundColor: Theme.of(context).backgroundColor,
        body: fetching
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
                    for (var column in columns)
                      DataColumn(
                        label: Text(column),
                      )
                  ], rows: []),
                )));
  }

  void getData() async {
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    await httpHelper.getDefinitionMetadata(widget.tile["name"]).then((value) {
      value["properties"].forEach((key, value) {
        print(key);
        columns.add(key);
      });
      setState(() {
        fetching = false;
      });
    });
  }
}
