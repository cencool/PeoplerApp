import 'dart:convert';

import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_attachment.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/person_item.dart';

String searchMapToJson(Map<String, dynamic> searchMap) {
  return jsonEncode(searchMap);
}

Map<String, dynamic> searchDataToMap(
  Person person,
  PersonDetail personDetail,
  PersonAttachment personAttachment,
  PersonItem personItem,
) {
  Map<String, dynamic> data = {
    'GeneralSearch': {
      'surname': person.surname,
      'name': person.name,
      'place': person.place,
      'gender': person.gender,
      'marital_status': personDetail.maritalStatus,
      'maiden_name': personDetail.maidenName,
      'address': personDetail.address,
      'note': personDetail.note,
      'caption': personAttachment.fileCaption,
      'item': personItem.item,
    },
    'sort': '-id',
    'filter': {},
  };
  return data;
}
