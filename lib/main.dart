import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:peopler/app/core/app_globals.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
// import 'package:peopler/globals/app_state.dart';
// import 'package:peopler/globals/dev_http.dart';
// import 'package:peopler/globals/app_globals.dart';
// import 'package:peopler/pages/start_page.dart';
// import 'package:provider/provider.dart' as provider;
import 'package:peopler/app/data/services/dev_http.dart' as dev_http;
import 'package:peopler/app/ui/pages/general_seach_page.dart';
import 'package:peopler/app/ui/pages/login_page.dart';
import 'package:peopler/app/ui/pages/start_page.dart';

final getIt = GetIt.instance;

const mode = 'layered';

void main() {
  if (mode == 'layered') {
    /// Hack to enable using self signed certificate for https
    HttpOverrides.global = dev_http.DevHttpOverrides();
    runApp(ProviderScope(child: PeoplerAppLayered()));
  } else {
    /// Hack to enable using self signed certificate for https
    // HttpOverrides.global = DevHttpOverrides();
    // getIt.registerSingleton<AppGlobals>(AppGlobals());
    // runApp(const PeoplerApp());
    return;
  }
}

/*
class PeoplerApp extends StatelessWidget {
  const PeoplerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: Builder(builder: (context) {
        return MaterialApp(
          scaffoldMessengerKey: getIt<AppGlobals>().messengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Peopler',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          home: StartPage(),
        );
      }),
    );
  }
}
*/

class PeoplerAppLayered extends ConsumerWidget {
  const PeoplerAppLayered({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool appStateIsInitialized = ref.watch(appStateProvider.select((state) => state.isInitialized));
    return MaterialApp(
      scaffoldMessengerKey: ref.read(appGlobalsProvider).messengerKey,
      routes: {
        '/login': (context) => const LoginPage(),
        '/search': (context) => const GeneralSearchPage(),
      },
      home: Scaffold(
        body: (appStateIsInitialized)
            ? StartPage()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
