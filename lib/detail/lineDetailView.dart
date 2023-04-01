import 'package:flutter/material.dart';
import 'dart:convert';

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
          return const DateTimePickerTextField();
        }
    }
    return Text('Unknown type: $type');
  }
}

/*
    return Column(
      children: [
           switch (widget.type) {
            case String:
              TextField(
                style: Theme.of(context).textTheme.titleLarge,
                controller: widget.controller,
                keyboardType: TextInput
                decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                labelText: widget.name,
                ),
              );,
              break;
            case int:
              TextField(
                style: Theme.of(context).textTheme.titleLarge,
                controller: widget.controller,
                decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                labelText: widget.name,
                ),
              );,
              break;

      }
      ],
     
    );








       switch (type) {
          case 'int': {
            return TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.name,
                hintText: 'e.g. 42',
              ),
            );
          } 
          case 'double':
            return TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: widget.name,
                hintText: 'e.g. 3.14',
              ),
            );
          case 'string':
            return TextField(
              decoration: InputDecoration(
                labelText: widget.name,
                hintText: 'e.g. Hello World',
              ),
            );
          case 'date':
            return TextField(
              keyboardType: TextInputType.datetime,
              style: Theme.of(context).textTheme.titleLarge,
              controller: widget.controller,
              decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              labelText: widget.name,
              hintText: 'e.g. MM/DD/YYYY',
              ),
            );
          default:
            return Text('Unknown type: $type');
        }
    */
