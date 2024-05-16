import 'dart:convert';

import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';

String searchMapToJson(Map<String, dynamic> searchMap) {
  return jsonEncode(searchMap);
}

Map<String, dynamic> searchDataToMap(
  Person person,
  PersonDetail personDetail,
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
    },
    'sort': '-id',
    'filter': {},
  };
  return data;
}
