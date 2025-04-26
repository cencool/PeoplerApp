import 'dart:convert';

import 'package:peopler/models/api.dart';

List<PersonItem> personItemFromJson(String str) =>
    List<PersonItem>.from(json.decode(str).map((x) => PersonItem.fromJson(x)));

String personItemToJson(List<PersonItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonItem {
  int id;
  int personId;
  String item;
  dynamic itemLink;

  PersonItem({
    required this.id,
    required this.personId,
    required this.item,
    this.itemLink,
  });

  factory PersonItem.fromJson(Map<String, dynamic> json) => PersonItem(
        id: json["id"],
        personId: json["person_id"],
        item: json["item"],
        itemLink: json["item_link"],
      );

  factory PersonItem.dummy() => PersonItem(id: -1, personId: -1, item: '', itemLink: '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "item": item,
        "item_link": itemLink,
      };

  Map<String, String> toMap() {
    return {
      "id": id.toString(),
      "person_id": personId.toString(),
      "item": item,
      "item_link": itemLink,
    };
  }

  static Future<PaginatedPersonItemList> getPaginatedPersonItemList({String query = ''}) async {
    final String url = '${Api.itemUrl}/list$query';
    var serverResponse =
        await Api.request(url: url, callerId: "PagPersItem", method: RequestMethod.get);
    if (serverResponse != null) {
      final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
      String jsonString = serverResponse.body;
      var jsonObject = json.decode(jsonString);
      final List<PersonItem> personItemList =
          List<PersonItem>.from(jsonObject.map((el) => PersonItem.fromJson(el)));
      return PaginatedPersonItemList(items: personItemList, pageCount: pageCount);
    }

    return PaginatedPersonItemList(items: <PersonItem>[]);
  }
}

class PaginatedPersonItemList {
  final int pageCount;
  final List<PersonItem> items;

  ///TODO shouldn't pageCount default be 0 ?
  PaginatedPersonItemList({required this.items, this.pageCount = 1});
}
