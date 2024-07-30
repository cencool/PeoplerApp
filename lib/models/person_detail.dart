import 'package:flutter/material.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peopler/widgets/snack_message.dart';

class PersonDetail {
  int id;
  int personId;
  String? maritalStatus;
  String? maidenName;
  String? note;
  String? address;

  PersonDetail({
    required this.id,
    required this.personId,
    this.maritalStatus,
    this.maidenName,
    this.note,
    this.address,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) => PersonDetail(
        id: json["id"] ?? -1,
        personId: json["person_id"] ?? '',
        maritalStatus: json["marital_status"] ?? '',
        maidenName: json["maiden_name"] ?? '',
        note: json["note"] ?? '',
        address: json["address"] ?? '',
      );

  PersonDetail.dummy(int pId)
      : id = -1,
        personId = pId {
    maritalStatus = '';
    maidenName = '';
    note = '';
    address = '';
  }

  PersonDetail.dummySearch()
      : id = -1,
        personId = -1 {
    maritalStatus = '';
    maidenName = '';
    note = '';
    address = '';
  }

  Future<Map<String, dynamic>> save() async {
    final String authString = await Credentials.getAuthString();

    if (id > -1) {
      // update  existing record
      String url = '${Api.personDetailUrl}/$personId';
      try {
        http.Response serverResponse = await http.put(Uri.parse(url),
            headers: {'Authorization': 'Basic $authString'}, body: toBodyPut());
        if (serverResponse.statusCode == 200) {
          String jsonString = serverResponse.body;
          if (jsonString == "null") {
            return {"error": true};
          }
          Map<String, dynamic> response = json.decode(jsonString);
          SnackMessage.showMessage(
              message: 'Details for:${response["person_id"]} saved', messageType: MessageType.info);
          return response;
        } else if (serverResponse.statusCode == 404) {
          SnackMessage.showMessage(
              message: 'No details data available...', messageType: MessageType.info);
        } else {
          SnackMessage.showMessage(
              message: 'Detail Save - Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      } on http.ClientException catch (e) {
        SnackMessage.showMessage(
          message: e.message,
          messageType: MessageType.error,
        );
      } catch (e) {
        debugPrint(e.toString());
        SnackMessage.showMessage(
            message: 'Exceptions:${e.toString()}', messageType: MessageType.error);
      }
    } else {
      // create new record
      String url = Api.personDetailUrl;
      try {
        http.Response serverResponse = await http.post(Uri.parse(url),
            headers: {'Authorization': 'Basic $authString'}, body: toBodyPost());
        if (serverResponse.statusCode == 200) {
          String jsonString = serverResponse.body;
          if (jsonString == "null") {
            return {"error": true};
          }
          Map<String, dynamic> response = json.decode(jsonString);
          SnackMessage.showMessage(
              message: 'Details for:${response["person_id"]} saved', messageType: MessageType.info);
          return response;
        } else if (serverResponse.statusCode == 404) {
          SnackMessage.showMessage(
              message: 'No details data available...', messageType: MessageType.info);
        } else {
          SnackMessage.showMessage(
              message: 'Detail Save - Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      } on http.ClientException catch (e) {
        SnackMessage.showMessage(
          message: e.message,
          messageType: MessageType.error,
        );
      } catch (e) {
        debugPrint(e.toString());
        SnackMessage.showMessage(
            message: 'Exceptions:${e.toString()}', messageType: MessageType.error);
      }
    }
    return {"error": true};
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "marital_status": maritalStatus,
        "maiden_name": maidenName,
        "note": note,
        "address": address,
      };
  Map<String, dynamic> toBodyPut() => {
        "id": id.toString(),
        "marital_status": maritalStatus,
        "maiden_name": maidenName,
        "note": note,
        "address": address,
      };
  Map<String, dynamic> toBodyPost() => {
        "person_id": personId.toString(),
        "marital_status": maritalStatus,
        "maiden_name": maidenName,
        "note": note,
        "address": address,
      };

  static Future<PersonDetail> getPersonDetail({required int id}) async {
    String url = '${Api.personDetailUrl}/$id';
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return PersonDetail.dummy(id);
        }
        var jsonObject = json.decode(jsonString);
        return PersonDetail.fromJson(jsonObject);
      } else if (serverResponse.statusCode == 404) {
        SnackMessage.showMessage(
            message: 'No details data available...', messageType: MessageType.info);
      } else {
        SnackMessage.showMessage(
            message: 'Get Detail - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
        message: e.message,
        messageType: MessageType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackMessage.showMessage(
        messageType: MessageType.error,
      );
    }
    return PersonDetail.dummy(id);
  }
}
