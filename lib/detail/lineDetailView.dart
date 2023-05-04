import 'package:flutter/material.dart';
import 'package:flutter_template/data/type.dart';
import 'dart:convert';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/detail/dateTimePickerTextField.dart';
import '../data/property.dart';

class LineDetailView extends StatefulWidget {
  const LineDetailView(
      {super.key,
      required this.controller,
      required this.name,
      required this.type,
      required this.data,
      required this.property,
      required this.id,
      required this.tile,
      required this.tiles,
      required this.tileDefinitions});

  final TextEditingController? controller;
  final String name;
  final Type? type;
  final Map<String, dynamic> data;
  final Property? property;
  final String id;
  final tile;
  final tiles;
  final tileDefinitions;

  @override
  State<LineDetailView> createState() => _LineDetailViewState();
}

class _LineDetailViewState extends State<LineDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Type? type = widget.type;
    switch (type) {
      case String:
        {
          return TextField(
              style: Theme.of(context).textTheme.titleLarge,
              controller: widget.controller,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                labelText: widget.name,
              ));
        }
      case int:
        {
          return TextField(
              style: Theme.of(context).textTheme.titleLarge,
              controller: widget.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                labelText: widget.name,
              ));
        }
      case double:
        {
          return TextField(
              style: Theme.of(context).textTheme.titleLarge,
              controller: widget.controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                labelText: widget.name,
              ));
        }
      case DateTime:
        {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              DateTimePickerTextField(
                initialDateTime: DateTime.parse(
                    widget.controller?.text ?? "2000-01-01 01:01:01"),
              ),
            ],
          );
        }
      case Array:
        {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => createPropertyListForArray(
                              widget.data, widget.property)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromARGB(255, 19, 21, 33),
                  ),
                ),
              ],
            ),
          );
          //createPropertyListForArray(widget.data, widget.property));
        }
    }
    return Text('Unknown type: $type');
  }

  DetailView createPropertyListForArray(
      Map<String, dynamic> data, Property? property) {
    int counter = 0;
    Map<String, dynamic> arrayData = {};
    List<Property> arrayProperties = [];

    //Add id to data and properties
    List<dynamic> types = ['string'];
    String format = '';
    TypeFormat idTypeFormat = TypeFormat(types, format);
    List<dynamic> typesClassList = [idTypeFormat];

    arrayData['_id'] = widget.id;

    arrayProperties.add(
        Property('_id', [], '', null, '', typesClassList, [], '', null, []));

    TypeFormat arrayTypeFormat =
        TypeFormat(property?.itemTypes, property?.itemTypes![0]);
    List<dynamic> typesClassArrayList = [arrayTypeFormat];

    //iterate over every entry of the array
    data[widget.name].forEach((dynamic entry) {
      //create new data for DetailView
      arrayData['${widget.name} $counter'] = entry;

      //create new propertiesList for DetailView
      arrayProperties.add(Property(
          '${widget.name} $counter', //String name
          [], //List<dynamic> types
          property?.itemRef, //String? ref
          null, //int? maxLength
          '', //String pattern
          typesClassArrayList, //List<dynamic>? typesClass
          property?.typeArray?.itemTypes, //List<dynamic>? itemTypes
          property?.typeArray?.itemRef, //String? itemRef
          property?.typeArray?.typeArray, //TypeArray? typeArray
          [] //List<dynamic> keys
          ));

      counter = counter + 1;
    });

    return DetailView(
      data: arrayData,
      properties: arrayProperties,
      tile: widget.tile,
      subSet: true,
      tiles: widget.tiles,
      tileDefinitions: widget.tileDefinitions,
    );
  }
}
