import 'package:flutter/material.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key, required this.data});
  final data;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    print(widget.data.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
