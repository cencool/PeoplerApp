import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/widgets/pluto_person_item_list.dart';
import 'package:provider/provider.dart';

enum ItemTabMode { view, edit }

class ItemTab extends StatefulWidget {
  const ItemTab({super.key});

  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
  ItemTabMode itemTabMode = ItemTabMode.view;

  void switchMode(ItemTabMode newMode) {
    setState(() {
      itemTabMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (itemTabMode) {
      case (ItemTabMode.view):
        return PlutoPersonItemList(
          onSwitch: switchMode,
        );
      case (ItemTabMode.edit):
        var personId = context.read<AppState>().activePerson.id;
        var itemId = context.read<AppState>().activePersonItem.id;
        debugPrint('Person id:$personId');
        debugPrint('Item id:$itemId');
        return Placeholder();
    }
  }
}
