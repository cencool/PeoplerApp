import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonTab build');
    return Center(
      child: Text('Person Tab'),
    );
  }
}
