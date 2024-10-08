import 'dart:convert';

import 'package:peopler/models/api.dart';
import 'package:peopler/models/person.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

import 'dummy_data.dart';

void main() {
  /// to create dummy response for correct request and incorrect request...
  int personId = 33;
  http.Response? getPersonMock({
    String callerId = 'defaultId',
    String url = '',
    RequestMethod method = RequestMethod.get,
    Headers headers = const {},
    Object? body = '',
    bool auth = true,
  }) {
    if (url == '${Api.personRestUrl}/$personId' && method == RequestMethod.get) {
      return http.Response(
          personToJson(
              Person(gender: 'm', id: personId, surname: 'Mock', name: 'Johnny', owner: 'tester')),
          200);
    } else {
      return null;
    }
  }

  http.Response? getPaginatedPersonListMock({
    String callerId = 'defaultId',
    String url = '',
    RequestMethod method = RequestMethod.get,
    Headers headers = const {},
    Object? body = '',
    bool auth = true,
  }) {
    if (url == Api.personRestUrl && method == RequestMethod.get) {
      generatePersons();
      return http.Response(jsonEncode(personListJasonable), 200, headers: {
        "content-type": "application/json; charset=utf-8",
        'x-pagination-page-count': "1",
      });
    } else {
      return null;
    }
  }

  test('Person object should be returned', () async {
    Api.isTesting = true;
    Api.mockCallback = getPersonMock;
    Person person = await Person.getPerson(id: personId);
    expect(person.id, personId);
  });

  test('Person list  should be returned', () async {
    Api.isTesting = true;
    Api.mockCallback = getPaginatedPersonListMock;
    PaginatedPersonList personList = await Person.getPaginatedPersonList();
    expect(personList.pageCount, 1);
    expect(personList.persons[2].id, 4);
    expect(personList.persons[2].name, 'Maťa');
  });
}
