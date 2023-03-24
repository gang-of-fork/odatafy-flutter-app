import 'package:flutter/material.dart';
import 'package:flutter_template/tiles/tilesWidget.dart';

class TilesView extends StatefulWidget {
  const TilesView({super.key, required this.tiles});
  final tiles;

  @override
  State<TilesView> createState() => _TilesViewState();
}

class _TilesViewState extends State<TilesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: const Image(image: AssetImage('/background.png'))),
            GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  for (var tile in widget.tiles) TilesWidget(tile: tile),
                ]),
          ]),
        ));
  }
}
