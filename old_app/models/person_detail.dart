import 'package:peopler/models/api.dart';
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
    // final String authString = await Credentials.getAuthString();

    if (id > -1) {
      // update  existing record
      String url = '${Api.personDetailUrl}/$personId';
      var serverResponse = await Api.request(
          url: url,
          callerId: 'detail save',
          method: RequestMethod.put,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(toBodyPut()));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return {"error": true};
        }
        Map<String, dynamic> response = json.decode(jsonString);
        SnackMessage.showMessage(
            message: 'Details for:${response["person_id"]} saved', messageType: MessageType.info);
        return response;
      }
    } else {
      // create new record
      String url = Api.personDetailUrl;
      var serverResponse = await Api.request(
          url: url,
          callerId: 'detail save',
          method: RequestMethod.post,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(toBodyPost()));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return {"error": true};
        }
        Map<String, dynamic> response = json.decode(jsonString);
        SnackMessage.showMessage(
            message: 'Details for:${response["person_id"]} saved', messageType: MessageType.info);
        return response;
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
    var serverResponse =
        await Api.request(url: url, callerId: 'personDetail', method: RequestMethod.get);
    if (serverResponse != null) {
      String jsonString = serverResponse.body;
      if (jsonString == "null") {
        return PersonDetail.dummy(id);
      }
      var jsonObject = json.decode(jsonString);
      return PersonDetail.fromJson(jsonObject);
    }
    return PersonDetail.dummy(id);
  }
}
