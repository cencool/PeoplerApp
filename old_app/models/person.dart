import 'package:peopler/models/api.dart';
import 'package:peopler/models/person_attachment.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'dart:convert';

import 'package:pluto_grid/pluto_grid.dart';

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
        surname: "N-A",
        name: '',
        place: '',
        gender: "?",
        owner: "N-A",
      );
  factory Person.dummySearch() => Person(
        id: -1,
        surname: "",
        name: '',
        place: '',
        gender: "",
        owner: "",
      );

  /// returns [PaginatedPersonList] based on query
  static Future<PaginatedPersonList> getPaginatedPersonList({String query = ''}) async {
    final String url = Api.personRestUrl + query;
    // final String authString = await Credentials.getAuthString();
    var serverResponse =
        await Api.request(url: url, method: RequestMethod.get, callerId: 'Person List');
    if (serverResponse != null) {
      final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '1');
      final int total = int.parse(serverResponse.headers['x-pagination-total-count'] ?? '0');
      final int perPage = int.parse(serverResponse.headers['x-pagination-per-page'] ?? '1');
      final int page = int.parse(serverResponse.headers['x-pagination-current-page'] ?? '1');
      String jsonString = serverResponse.body;
      var jsonObject = json.decode(jsonString);
      final List<Person> personList =
          List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
      return PaginatedPersonList(
          persons: personList,
          pageCount: pageCount,
          totalCount: total,
          pageSize: perPage,
          currentPage: page);
    } else {
      return PaginatedPersonList(persons: <Person>[]);
    }
  }

  static List<PlutoRow> getPlutoRows(List<Person> persons) {
    var tableRows = <PlutoRow>[];
    for (var person in persons) {
      tableRows.add(PlutoRow(
        cells: {
          'id': PlutoCell(value: person.id),
          'name': PlutoCell(value: person.name),
          'surname': PlutoCell(value: person.surname),
          'gender': PlutoCell(value: person.gender),
          'place': PlutoCell(value: person.place),
          'owner': PlutoCell(value: person.owner),
        },
        checked: false,
      ));
    }
    return tableRows;
  }

  static Future<PaginatedPersonList> getPaginatedPersonSearchList(
      {required String searchParams, required query}) async {
    String url = '${Api.personSearchUrl}?$query';
    var serverResponse = await Api.request(
        callerId: 'Person Search',
        url: url,
        method: RequestMethod.post,
        headers: {'Content-Type': 'application/json'},
        body: searchParams);
    if (serverResponse != null) {
      final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
      String jsonString = serverResponse.body;
      var jsonObject = json.decode(jsonString);
      final List<Person> personList =
          List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
      return PaginatedPersonList(persons: personList, pageCount: pageCount);
    }
    return PaginatedPersonList(persons: <Person>[]);
  }

  static Future<Person> getPerson({required int id}) async {
    String url = '${Api.personRestUrl}/$id';
    if (id > -1) {
      var serverResponse =
          await Api.request(callerId: 'getPerson', url: url, method: RequestMethod.get);
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        return Person.fromJson(jsonObject);
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
  Future<Map<String, dynamic>> save() async {
    // final String authString = await Credentials.getAuthString();

    if (id > -1) {
      // update  existing record
      String url = '${Api.personRestUrl}/$id';
      var serverResponse = await Api.request(
          url: url,
          callerId: 'Person Save',
          method: RequestMethod.put,
          headers: {"Content-Type": "application/json"},
          body: personToJson(this));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return {"error": true};
        }
        SnackMessage.showMessage(
          message: 'Person :$id updated',
          messageType: MessageType.info,
        );
        return json.decode(jsonString);
      }
    } else {
      // create new record
      String url = Api.personRestUrl;
      var serverResponse = await Api.request(
          url: url,
          callerId: 'Person Save',
          method: RequestMethod.post,
          headers: {"Content-Type": "application/json"},
          body: personToJson(this));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return {"error": true};
        }
        Map<String, dynamic> response = json.decode(jsonString);
        SnackMessage.showMessage(
            message: 'Person: ${response["id"]} saved', messageType: MessageType.info);
        return response;
      }
    }
    return {"error": true};
  }

  static Future<bool> delete(int id) async {
    String url = '${Api.personRestUrl}/$id';
    var serverResponse = await Api.request(
      url: url,
      callerId: 'Person delete',
      method: RequestMethod.delete,
    );
    if (serverResponse != null) {
      SnackMessage.showMessage(message: 'Person: $id deleted', messageType: MessageType.info);
      return true;
    }
    return false;
  }

  Future<List<PersonAttachment>> getAttachmentList({required int id}) async {
    String url = '${Api.attachmentUrl}/list?personId=$id';
    if (id > -1) {
      var serverResponse =
          await Api.request(url: url, callerId: 'getAttachmentList', method: RequestMethod.get);
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        return personAttachmentFromJson(jsonString);
      }
    }
    return personAttachmentFromJson('[]');
  }
}

class PaginatedPersonList {
  final int pageCount;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final List<Person> persons;

  ///TODO shouldn't pageCount default be 0 ?
  PaginatedPersonList(
      {required this.persons,
      this.pageCount = 1,
      this.currentPage = 1,
      this.pageSize = 10,
      this.totalCount = 1});
}
