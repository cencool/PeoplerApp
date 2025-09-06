import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonTabForm extends ConsumerStatefulWidget {
  const PersonTabForm({super.key});
  @override
  ConsumerState<PersonTabForm> createState() => _MyPersonTabFormState();
}

class _MyPersonTabFormState extends ConsumerState<PersonTabForm> {
  @override
  Widget build(BuildContext context) {
    debugPrint('PersonTabForm build');
    return const Center(
      child: Text('Person Tab Form'),
    );
  }
}
