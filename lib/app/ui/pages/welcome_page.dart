import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state_notifier.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('WelcomePage build');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // "USER:${getIt<AppState>().user!.id}",
          "USER:${ref.watch(appStateProvider.select((state) => state.credentials))?.userName ?? ''}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(child: Text('Welcome to Peopler')),
    );
  }
}
