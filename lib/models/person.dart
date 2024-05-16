import 'package:peopler/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/models/credentials.dart';
import 'package:flutter/material.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
  int id;
  String surname;
  String? name;
  String gender;
  String? place;
  String owner;

  Person(
      {this.id = -1,
      required this.surname,
      this.name,
      this.place,
      required this.gender,
      required this.owner});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"] ?? -1,
        surname: json["surname"] ?? '',
        name: json["name"] ?? '',
        place: json["place"] ?? '',
        gender: json["gender"] ?? '',
        owner: json["owner"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "surname": surname,
        "name": name,
        "gender": gender,
        "place": place,
        "owner": owner
      };

  factory Person.dummy() => Person(
        id: -1,
        surname: "N/A",
        name: '',
        place: '',
        gender: "?",
        owner: "N/A",
      );
  factory Person.dummySearch() => Person(
        id: -1,
        surname: "",
        name: '',
        place: '',
        gender: "",
        owner: "",
      );

  /// deletes person with given id
  /// TODO is not checked yet
  static Future<http.Response> deletePerson({required int id, required messengerKey}) async {
    final String url = '${Api.personRestUrl}/$id';
    final String authString = await Credentials.getAuthString();
    try {
      return await http.delete(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
          messengerKey: messengerKey, message: e.message, messageType: MessageType.error);
      return http.Response('', 599);
    }
  }

  /// returns [PaginatedPersonList] based on query
  static Future<PaginatedPersonList> getPaginatedPersonList(
      {String query = '', required messengerKey}) async {
    final String url = Api.personRestUrl + query;
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final List<Person> personList =
            List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
        return PaginatedPersonList(persons: personList, pageCount: pageCount);
      } else {
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Person List - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
          messengerKey: messengerKey, message: e.message, messageType: MessageType.error);
    }
    return PaginatedPersonList(persons: <Person>[]);
  }

  static Future<PaginatedPersonList> getPaginatedPersonSearchList(
      {required String searchParams, required query, required messengerKey}) async {
    final String authString = await Credentials.getAuthString();
    String url = '${Api.personSearchUrl}?$query';
    try {
      http.Response serverResponse = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Basic $authString', 'Content-Type': 'application/json'},
          body: searchParams);
      if (serverResponse.statusCode == 200) {
        final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final List<Person> personList =
            List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
        return PaginatedPersonList(persons: personList, pageCount: pageCount);
      } else {
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Person List - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
          messengerKey: messengerKey, message: e.message, messageType: MessageType.error);
    }
    return PaginatedPersonList(persons: <Person>[]);
  }

  static Future<Person> getPerson({required int id, required messengerKey}) async {
    String url = '${Api.personRestUrl}/$id';
    final String authString = await Credentials.getAuthString();
    if (id > -1) {
      try {
        http.Response serverResponse =
            await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
        if (serverResponse.statusCode == 200) {
          String jsonString = serverResponse.body;
          var jsonObject = json.decode(jsonString);
          return Person.fromJson(jsonObject);
        } else {
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'Get Person - Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      } on http.ClientException catch (e) {
        SnackMessage.showMessage(
            message: e.message, messageType: MessageType.error, messengerKey: messengerKey);
      }
    }
    return Person.dummy();
  }

  Map<String, dynamic> toBodyPut() => {
        "name": name,
        "surname": surname,
        "place": place,
        "gender": gender,
        "owner": owner,
      };
  Map<String, dynamic> toBodyPost() => {
        "name": name,
        "surname": surname,
        "place": place,
        "gender": gender,
        "owner": owner,
      };
  Future<Map<String, dynamic>> save(GlobalKey<ScaffoldMessengerState> messengerKey) async {
    final String authString = await Credentials.getAuthString();

    if (id > -1) {
      // update  existing record
      String url = '${Api.personRestUrl}/$id';
      try {
        http.Response serverResponse = await http.put(Uri.parse(url),
            headers: {'Authorization': 'Basic $authString', "Content-Type": "application/json"},
            // body: toBodyPut());
            body: personToJson(this));
        if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
          String jsonString = serverResponse.body;
          if (jsonString == "null") {
            return {"error": true};
          }
          SnackMessage.showMessage(
              message: 'Person :$id saved',
              messageType: MessageType.info,
              messengerKey: messengerKey);
          return json.decode(jsonString);
        } else if (serverResponse.statusCode == 404) {
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'No person data available...',
              messageType: MessageType.info);
        } else {
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'Person Save - Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      } on http.ClientException catch (e) {
        SnackMessage.showMessage(
            message: e.message, messageType: MessageType.error, messengerKey: messengerKey);
      } catch (e) {
        debugPrint(e.toString());
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Exceptions:${e.toString()}',
            messageType: MessageType.error);
      }
    } else {
      // create new record
      String url = Api.personRestUrl;
      try {
        http.Response serverResponse = await http.post(Uri.parse(url),
            headers: {'Authorization': 'Basic $authString', "Content-Type": "application/json"},
            // body: toBodyPost());
            body: personToJson(this));
        if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
          String jsonString = serverResponse.body;
          if (jsonString == "null") {
            return {"error": true};
          }
          Map<String, dynamic> response = json.decode(jsonString);
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'Person: ${response["id"]} saved',
              messageType: MessageType.info);
          return response;
        } else if (serverResponse.statusCode == 404) {
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'No person data available...',
              messageType: MessageType.info);
        } else {
          SnackMessage.showMessage(
              messengerKey: messengerKey,
              message: 'Person Save - Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      } on http.ClientException catch (e) {
        SnackMessage.showMessage(
            message: e.message, messageType: MessageType.error, messengerKey: messengerKey);
      } catch (e) {
        debugPrint(e.toString());
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Exceptions:${e.toString()}',
            messageType: MessageType.error);
      }
    }
    return {"error": true};
  }

  static Future<bool> delete(
    int id, {
    required GlobalKey<ScaffoldMessengerState> messengerKey,
  }) async {
    final String authString = await Credentials.getAuthString();
    String url = '${Api.personRestUrl}/$id';
    try {
      http.Response serverResponse =
          await http.delete(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode >= 200 && serverResponse.statusCode < 300) {
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Person: $id deleted',
            messageType: MessageType.info);
        return true;
      } else if (serverResponse.statusCode == 404) {
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'No Person $id available...',
            messageType: MessageType.error);
      } else {
        SnackMessage.showMessage(
            messengerKey: messengerKey,
            message: 'Person delete - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
          message: e.message, messageType: MessageType.error, messengerKey: messengerKey);
    } catch (e) {
      debugPrint(e.toString());
      SnackMessage.showMessage(
          messengerKey: messengerKey,
          message: 'Exceptions:${e.toString()}',
          messageType: MessageType.error);
    }
    return false;
  }
}

class PaginatedPersonList {
  final int pageCount;
  final List<Person> persons;

  ///TODO shouldn't pageCount default be 0 ?
  PaginatedPersonList({required this.persons, this.pageCount = 1});
}
