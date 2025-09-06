import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/widgets/person_tab_form.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonTab build');
    return Stack(children: [
      ListView(
        children: [
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Person Photo')],
            ),
          ),
          const SizedBox(height: 10.0),
          PersonTabForm(),
        ],
      )
    ]);
  }
}
