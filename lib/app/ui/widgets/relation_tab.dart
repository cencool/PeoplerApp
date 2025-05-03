import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RelationTab extends ConsumerWidget {
  const RelationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('RelationTab build');
    return Center(
      child: Text('Relation Tab'),
    );
  }
}
