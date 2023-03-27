import 'package:flutter/material.dart';
import 'package:flutter_template/home/widgets/tilesWidget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        body: Stack(children: [
          ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: const Image(image: AssetImage('assets/background.png'))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(widget.tiles.length, (int index) {
                  return AnimationConfiguration.staggeredGrid(
                      columnCount: 2,
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: ScaleAnimation(
                          scale: 0.5,
                          child: FadeInAnimation(
                              child: TilesWidget(tile: widget.tiles[index]))));
                })
                /*for (var tile in widget.tiles)
                    AnimationConfiguration.staggeredGrid(
                      position: widget.tiles.indexOf(tile),
                      duration: const Duration(milliseconds: 1000),
                      columnCount: 3,
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: TilesWidget(tile: tile),
                        ),
                      ),
                    )*/
                ),
          ),
        ]));
  }
}
