import 'package:flutter/material.dart';

enum GeneralSearchPageMode { search, results }

class GeneralSearchPage extends StatefulWidget {
  const GeneralSearchPage({super.key});

  @override
  State<GeneralSearchPage> createState() => _GeneralSearchPageState();
}

class _GeneralSearchPageState extends State<GeneralSearchPage> {
  GeneralSearchPageMode generalSearchPageMode = GeneralSearchPageMode.search;

  void switchMode(GeneralSearchPageMode newMode) {
    setState(() {
      generalSearchPageMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('GeneralSearchPage'));
  }
}
