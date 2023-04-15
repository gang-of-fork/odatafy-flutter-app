import 'dart:convert';
import 'package:flutter_template/data/property.dart';
import 'package:flutter_template/home/tilesView.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/appBar.dart';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/home/widgets/tilesWidget.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as Badges;

import '../data/httpHelper.dart';
import '../data/tile.dart';
import 'filterView.dart';

class TableView extends StatefulWidget {
  TableView(
      {super.key,
      required this.tile,
      this.filter = const [],
      required this.tiles,
      required this.tileDefinition,
      required this.tileDefinitions});
  final tile;
  final tiles;
  final List<String> filter;
  final List<Tile> tileDefinitions;
  final Tile tileDefinition;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final double maxWidth = 200;
  bool fetchingColumns = false;
  bool fetchingContent = true;
  int page = 0;

  String searchWord = "";

  late HttpHelper httpHelper;

  List<List<DataRow>> listRows = [];
  List<DataRow> rows = [];
  List<String> dropdownValues = [];
  List<String> filter = [];

  late dynamic metadata;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                getContent(0, searchWord);
                                              });
                                            }))),
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Badges.Badge(
                                  badgeStyle: Badges.BadgeStyle(
                                      badgeColor:
                                          Theme.of(context).primaryColor),
                                  badgeAnimation:
                                      const Badges.BadgeAnimation.rotation(),
                                  position: Badges.BadgePosition.custom(
                                      end: 5, top: 3),
                                  badgeContent: Text(filter.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FilterView(
                                                      tile: widget.tile,
                                                      tileDefinition:
                                                          widget.tileDefinition,
                                                      filter: filter,
                                                    ))).then((value) {
                                          setState(() {
                                            filter = value;
                                            getContent(0, "");
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.filter_alt)),
                                )
                              ]),
                            ),
                            DataTable(
                                columnSpacing: 16.0,
                                showCheckboxColumn: false,
                                columns: [
                                  for (var property
                                      in widget.tileDefinition.properties)
                                    DataColumn(
                                      label: Text(property.name),
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
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    getContent(0, "");
  }

  getContent(int page, String search) async {
    setState(() {
      fetchingContent = true;
      rows = [];
    });
    await httpHelper.getData(widget.tile["url"], search, filter).then((value) {
      for (var row in value) {
        var dataRow = DataRow(
            cells: [],
            onSelectChanged: (bool) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailView(
                        data: row,
                        properties: widget.tileDefinition.properties)),
              );
            });
        for (var property in widget.tileDefinition.properties) {
          var formats = [];
          var types = [];
          for (var typeClass in property.typesClass) {
            formats.add(typeClass.format);
            typeClass.types.forEach((value) {
              types.add(value);
            });
          }
          var date = row[property.name];
          if (types.contains("array")) {
            dataRow.cells.add(convertListToDropDown(date, property.itemRef));
          } else if (formats.contains("date-time")) {
            dataRow.cells.add(convertDateToString(date));
          } else {
            dataRow.cells.add(DataCell(Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      date.toString(),
                    ),
                  ),
                  property.ref != ""
                      ? IconButton(
                          icon: const Icon(Icons.link),
                          onPressed: () {
                            navigateToRefTable(property.ref, date.toString());
                          },
                        )
                      : Container()
                ],
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

  DataCell convertListToDropDown(date, ref) {
    date = date.map<String>((item) {
      return item.toString();
    }).toList();
    var dropdownValue = date[0];
    dropdownValues.add(dropdownValue);
    return (DataCell(DropdownButton<String>(
      dropdownColor: Theme.of(context).backgroundColor,
      value: dropdownValues[dropdownValues.indexOf(dropdownValue)],
      icon: const Icon(Icons.arrow_downward, size: 12),
      elevation: 16,
      onChanged: (String? newValue) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValues[dropdownValues.indexOf(dropdownValue)] = newValue!;
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
              ref != ""
                  ? IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () {
                        navigateToRefTable(ref, value.toString());
                      },
                    )
                  : Container()
            ],
          ),
        );
      }).toList(),
    )));
  }

  DataCell convertDateToString(date) {
    String dateTime = DateFormat('yyyy-MM-dd – kk:mm')
        .format(DateTime.parse(date.toString()));
    return (DataCell(Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(overflow: TextOverflow.ellipsis, dateTime),
    )));
  }

  void navigateToRefTable(String ref, String id) {
    String tileName = ref.split("/").last;
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
