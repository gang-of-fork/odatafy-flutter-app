import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/theme.dart';
import 'package:flutter_template/home/tilesView.dart';

import 'appBar.dart';
import 'data/httpHelper.dart';
import 'data/tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: odatafyTheme(),
      home: const MyHomePage(title: 'Odatafy Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HttpHelper httpHelper;

  var tiles = [];
  List<Tile> tileDefinitions = [];
  bool fetching = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarIcon(actions: [], withBackButton: false),
        backgroundColor: Theme.of(context).backgroundColor,
        body: fetching
            ? ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: const Image(image: AssetImage('assets/background.png')))
            : TilesView(
                tiles: tiles,
                tileDefinitions: tileDefinitions,
              ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void getData() async {
    httpHelper = HttpHelper.HttpHelperWithoutAuthority();
    await httpHelper.getServiceEntryPoint().then((value) => tiles = value);
    await httpHelper
        .getMetadataFormatted()
        .then((value) => tileDefinitions = value);
    setState(() {
      fetching = false;
    });
  }
}
