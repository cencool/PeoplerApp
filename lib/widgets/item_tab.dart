import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person_item.dart';
import 'package:peopler/widgets/pluto_person_item_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

enum ItemTabMode { view, edit, add }

enum ApiAction { add, update, delete }

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
        return Stack(children: [
          PlutoPersonItemList(
            onSwitch: switchMode,
          ),
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                switchMode(ItemTabMode.add);
              },
              child: Icon(Icons.add),
            ),
          )
        ]);
      case (ItemTabMode.edit):
        var personId = context.read<AppState>().activePerson.id;
        var itemId = context.read<AppState>().activePersonItem.id;
        debugPrint('Person id:$personId');
        debugPrint('Item id:$itemId');
        return ItemEdit(
          onSwitch: switchMode,
        );
      case (ItemTabMode.add):
        return ItemAdd(onSwitch: switchMode);
    }
  }
}

class ItemAdd extends StatefulWidget {
  const ItemAdd({required this.onSwitch, super.key});
  final Function(ItemTabMode newMode) onSwitch;

  @override
  State<ItemAdd> createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAdd> {
  late PersonItem addedItem = PersonItem.dummy();
  late TextEditingController itemAddController = TextEditingController(text: '');

  @override
  void dispose() {
    itemAddController.dispose();
    super.dispose();
  }

  void setActiveData() {
    addedItem.item = itemAddController.text;
    addedItem.personId = context.read<AppState>().activePerson.id;
    context.read<AppState>().activePersonItem = addedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: itemAddController),
          ),
        ]),
        Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: () {
              setActiveData();
              showDialog(
                  context: context,
                  builder: (context) => ItemSaveDialog(
                        onModeSwitch: widget.onSwitch,
                        action: ApiAction.add,
                        key: ValueKey('add'),
                      ),
                  barrierDismissible: false);
            },
            child: Icon(Icons.check),
          ),
        ),
      ],
    );
  }
}

class ItemEdit extends StatefulWidget {
  const ItemEdit({required this.onSwitch, super.key});
  final Function(ItemTabMode newMode) onSwitch;

  @override
  State<ItemEdit> createState() => _ItemEditState();
}

class _ItemEditState extends State<ItemEdit> {
  /// TODO nezbudnut vratit activeItem na dummy ked sa vratime
  late PersonItem editedItem = context.read<AppState>().activePersonItem;
  late TextEditingController itemEditController = TextEditingController(text: editedItem.item);

  @override
  void dispose() {
    itemEditController.dispose();
    super.dispose();
  }

  void setActiveData() {
    editedItem.item = itemEditController.text;
    editedItem.personId = context.read<AppState>().activePerson.id;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: itemEditController),
          ),
        ]),
        ElevatedButton(
          onPressed: () {
            setActiveData();
            showDialog(
                context: context,
                builder: (context) => ItemSaveDialog(
                      onModeSwitch: widget.onSwitch,
                      action: ApiAction.update,
                      key: ValueKey('update'),
                    ),
                barrierDismissible: false);
          },
          child: Icon(Icons.check),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => ItemSaveDialog(
                        onModeSwitch: widget.onSwitch,
                        action: ApiAction.delete,
                        key: ValueKey('delete'),
                      ),
                  barrierDismissible: false);
            },
            child: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}

class ItemSaveDialog extends StatelessWidget {
  const ItemSaveDialog({required this.action, required this.onModeSwitch, super.key});
  final ApiAction action;
  final Function(ItemTabMode newMode) onModeSwitch;
  String createUrl(ApiAction action) {
    switch (action) {
      case (ApiAction.add):
        return '${Api.itemUrl}/add';
      case (ApiAction.update):
        return '${Api.itemUrl}/update';
      case (ApiAction.delete):
        return '${Api.itemUrl}/delete';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    PersonItem activeItem = context.read<AppState>().activePersonItem;
    return Dialog(
      child: SizedBox(
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (action != ApiAction.delete)
                  ? const Text('Do you want to save item?')
                  : const Text('Do you want to delete item?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      debugPrint('Yes save pressed');
                      String authString = await Credentials.getAuthString();
                      String url = createUrl(action);
                      var response = await http.post(Uri.parse(url),
                          headers: {'Authorization': 'Basic $authString'},
                          body: activeItem.toMap());
                      if (response.statusCode == 200) {
                        debugPrint('Item save action successfull');
                      } else {
                        debugPrint('Response code: ${response.statusCode}');
                      }

                      /// TODO: check if can be done better ie .then()...
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      onModeSwitch(ItemTabMode.view);
                      // onModeSwitch(AttachmentTabMode.view, activeAttachmentId);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No save pressed');
                      Navigator.pop(context);
                      onModeSwitch(ItemTabMode.view);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
