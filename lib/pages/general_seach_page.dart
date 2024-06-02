import 'package:flutter/material.dart';
import 'package:peopler/widgets/general_search_tab.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: (generalSearchPageMode == GeneralSearchPageMode.search)
            ? const Text(
                'Search',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Search Results',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GeneralSearchTab(
        onModeSwitch: switchMode,
      ),
    );
  }
}
