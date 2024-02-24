import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'person.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peopler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const IndexPage(),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  String serverResponse = '';
  List<dynamic>? decodedResponseList;
  Map<String, dynamic>? decodedResponseMap;
  int? responseStatus;
  Person? person;

  void getResponse() async {
    var url = Uri.http('peopler.localhost:8000', 'api1/people/13');
    var response = await http.delete(url);
    setState(() {
      responseStatus = response.statusCode;
      serverResponse = response.body;
      if (jsonDecode(serverResponse) is List<dynamic>) {
        decodedResponseList = jsonDecode(serverResponse);
      } else {
        decodedResponseMap = jsonDecode(serverResponse);
        person = Person.fromJson(decodedResponseMap!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'People  list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ElevatedButton(
              onPressed: () => {getResponse()}, child: Icon(Icons.download)),
          Text('Status: $responseStatus'),
          Text('Surname: ${person?.surname ?? "undefined"}'),
          SelectableText(serverResponse),
        ]),
      ),
    );
  }
}
