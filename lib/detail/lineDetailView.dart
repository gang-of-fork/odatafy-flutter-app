import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_template/detail/detailView.dart';
import 'package:flutter_template/detail/dateTimePickerTextField.dart';

class LineDetailView extends StatefulWidget {
  const LineDetailView(
      {super.key,
      required this.controller,
      required this.name,
      required this.type});
  final TextEditingController? controller;
  final String name;
  final Type? type;

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
          return DateTimePickerTextField(
            initialDateTime: DateTime.parse(
                widget.controller?.text ?? "2000-01-01 01:01:01"),
          );
        }
      case Array:
        {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Hier kommt eine DetailView"),
          );
        }
    }
    return Text('Unknown type: $type');
  }
}
