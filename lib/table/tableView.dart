import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/home/widgets/tilesWidget.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart';

import '../data/httpHelper.dart';

class TableView extends StatefulWidget {
  TableView({super.key, required this.tile, this.filter = const []});
  final tile;
  final filter;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final double maxWidth = 200;
  bool fetchingColumns = true;
  bool fetchingContent = true;
  int page = 0;

  String searchWord = "";

  late HttpHelper httpHelper;

  List<Map<String, dynamic>> columns = [];
  List<List<DataRow>> listRows = [];
  List<DataRow> rows = [];
  List<String> dropdownValues = [];
  List filter = [];

  late dynamic metadata;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController(text: searchWord);
    return Scaffold(
        appBar: AppBarIcon(actions: []),
        backgroundColor: Theme.of(context).backgroundColor,
        body: fetchingColumns
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                              child: Text(
                                widget.tile["name"],
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            //Searchfield
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 8, 0, 0),
                              child: Row(children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 105,
                                  child: TextField(
                                    controller: searchController,
                                    onSubmitted: (value) {
                                      searchWord = value;
                                      getContent(0, searchWord);
                                    },
                                    onChanged: (value) {
                                      searchWord = value;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Search",
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        prefixIcon: IconButton(
                                          onPressed: () {
                                            getContent(0, searchWord);
                                          },
                                          icon: Icon(Icons.search),
                                          color: Colors.white,
                                        ),
                                        suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                            color: Colors.white,
                                            onPressed: (() {
                                              setState(() {
                                                searchController.clear();
                                                searchWord = "";
                                              });
                                            }))),
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Badge(
                                  badgeStyle: BadgeStyle(
                                      badgeColor:
                                          Theme.of(context).primaryColor),
                                  badgeAnimation: BadgeAnimation.rotation(),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {},
                                      icon: Icon(Icons.filter_alt)),
                                  position:
                                      BadgePosition.custom(end: 5, top: 3),
                                  badgeContent: Text(filter.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                )
                              ]),
                            ),
                            DataTable(
                                columnSpacing: 16.0,
                                showCheckboxColumn: false,
                                columns: [
                                  for (var column in columns)
                                    DataColumn(
                                      label: Text(column.keys.first),
                                    )
                                ],
                                rows: rows),
                            fetchingContent
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Container()
                          ])),
                )));
  }

  void getData() async {
    getColumns();
    getContent(0, "");
  }

  getColumns() async {
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    await httpHelper.getDefinitionMetadata(widget.tile["name"]).then((value) {
      metadata = value;
      value["properties"].forEach((key, propValue) {
        Map<String, dynamic> column = {key: propValue};
        columns.add(column);
      });
      setState(() {
        fetchingColumns = false;
      });
    });
  }

  getContent(int page, String search) async {
    await httpHelper.getData(widget.tile["url"], search).then((value) {
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
                      Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Text(value,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      ref
                          ? IconButton(
                              icon: const Icon(Icons.link),
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
          } else if (DateTime.tryParse(date.toString()) != null) {
            String dateTime = DateFormat('yyyy-MM-dd – kk:mm')
                .format(DateTime.parse(date.toString()));
            dataRow.cells.add(DataCell(Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(overflow: TextOverflow.ellipsis, dateTime),
            )));
          } else {
            dataRow.cells.add(DataCell(Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                overflow: TextOverflow.ellipsis,
                date.toString(),
              ),
            )));
          }
        }
        rows.add(dataRow);
      }
      setState(() {
        fetchingContent = false;
      });
    });
  }
}
