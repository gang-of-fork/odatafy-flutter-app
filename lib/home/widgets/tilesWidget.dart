import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_template/table/tableView.dart';

import '../../data/tile.dart';

class TilesWidget extends StatefulWidget {
  const TilesWidget(
      {super.key,
      required this.tile,
      required this.tiles,
      required this.tileDefinition,
      required this.tileDefinitions});
  final tile;
  final tiles;
  final Tile tileDefinition;
  final List<Tile> tileDefinitions;

  @override
  State<TilesWidget> createState() => _TilesWidgetState();
}

class _TilesWidgetState extends State<TilesWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TableView(
                  tile: widget.tile,
                  tileDefinition: widget.tileDefinition,
                  tileDefinitions: widget.tileDefinitions,
                  tiles: widget.tiles),
            ));
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            blendMode: BlendMode.luminosity,
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.1),
                  border: Border.all(
                      width: 3.0, color: Theme.of(context).primaryColorLight),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  widget.tile["name"] ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          )),
    );
  }
}
