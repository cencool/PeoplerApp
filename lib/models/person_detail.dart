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
        id: json["id"],
        personId: json["person_id"],
        maritalStatus: json["marital_status"],
        maidenName: json["maiden_name"],
        note: json["note"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "marital_status": maritalStatus,
        "maiden_name": maidenName,
        "note": note,
        "address": address,
      };

  static Future<PersonDetail?> getPersonDetail(
      {required int id, required BuildContext context}) async {
    String url = '${Api.personDetailUrl}/$id';
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        return PersonDetail.fromJson(jsonObject);
      } else if (serverResponse.statusCode == 404) {
        if (context.mounted) {
          SnackMessage.showMessage(
              context: context,
              message: 'No details data available...',
              messageType: MessageType.info);
        }
      } else {
        if (context.mounted) {
          SnackMessage.showMessage(
              context: context,
              message: 'Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      }
    } on http.ClientException catch (e) {
      if (context.mounted) {
        SnackMessage.showMessage(
            context: context, message: e.message, messageType: MessageType.error);
      }
    }
    return null;
  }
}
