import 'package:flutter/material.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/pages/index_page.dart';
import 'package:peopler/models/credentials.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final Future<bool> loginStatus = Credentials.isLoggedIn();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peopler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: loginStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data!) {
              // return Text('Logged In');
              return const IndexPage();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
