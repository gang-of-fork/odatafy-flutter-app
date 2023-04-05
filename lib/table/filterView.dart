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

  @override
  void initState() {
    filter = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarIcon(actions: [], withBackButton: false),
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(shrinkWrap: true, children: [
          for (var singleFilter in filter)
            (InputChip(
              label: Text(singleFilter),
              onSelected: ((value) => {}),
              onDeleted: (() => {filter.remove(singleFilter)}),
            )),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, widget.filter);
            },
            child: const Text("Filter anwenden"),
          ),
        ]));
  }
}
