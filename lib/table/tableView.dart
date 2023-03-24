import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/home/widgets/tilesWidget.dart';
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

  List<Map<String, dynamic>> columns = [];
  List<DataRow> rows = [];
  List<String> dropdownValues = [];

  late dynamic metadata;

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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          for (var column in columns)
                            DataColumn(
                              label: Text(column.keys.first),
                            )
                        ],
                        rows: rows),
                  ),
                )));
  }

  void getData() async {
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    await httpHelper.getDefinitionMetadata(widget.tile["name"]).then((value) {
      metadata = value;
      value["properties"].forEach((key, propValue) {
        Map<String, dynamic> column = {key: propValue};
        columns.add(column);
      });
    });
    await httpHelper.getData(widget.tile["url"]).then((value) {
      for (var row in value) {
        var dataRow = DataRow(
            cells: [],
            onSelectChanged: (bool) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailView(data: row)),
              );
            });
        for (var column in columns) {
          var ref = column.toString().contains("\$ref");
          var date = row[column.keys.first];
          if (date.runtimeType == List<dynamic>) {
            date = date.map<String>((item) {
              return item.toString();
            }).toList();
            var dropdownValue = date[0];
            dropdownValues.add(dropdownValue);
            dataRow.cells.add(DataCell(DropdownButton<String>(
              dropdownColor: Theme.of(context).backgroundColor,
              value: dropdownValues[dropdownValues.indexOf(dropdownValue)],
              icon: const Icon(Icons.arrow_downward, size: 12),
              elevation: 16,
              onChanged: (String? newValue) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValues[dropdownValues.indexOf(dropdownValue)] =
                      newValue!;
                });
              },
              items: date.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value, style: Theme.of(context).textTheme.bodySmall),
                      ref
                          ? IconButton(
                              icon: Icon(Icons.link),
                              onPressed: () {
                                // TODO: implement link
                              },
                            )
                          : Container()
                    ],
                  ),
                );
              }).toList(),
            )));
          } else {
            dataRow.cells.add(DataCell(Text(date.toString())));
          }
        }
        rows.add(dataRow);
      }
      setState(() {
        fetching = false;
      });
    });
  }
}
