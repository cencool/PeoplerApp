import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemTab extends ConsumerWidget {
  const ItemTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ItemTab build');
    return Center(
      child: Text('Item Tab'),
    );
  }
}
