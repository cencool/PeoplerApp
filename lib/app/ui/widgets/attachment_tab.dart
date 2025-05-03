import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttachmentTab extends ConsumerWidget {
  const AttachmentTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('AttachmentTab build');
    return Center(
      child: Text('Attachment Tab'),
    );
  }
}
