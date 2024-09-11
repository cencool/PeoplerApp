import 'package:peopler/models/person.dart';

Map<String, dynamic> persons = {
  'ids': [1, 2, 4, 7, 10, 11, 12],
  'surnames': ['Klajbas', 'Hladky', 'Prieporna', 'Jokel', 'Hlavata', 'Halas', 'Rambo'],
  'names': ['Jan', 'Peter', 'Maťa', 'Jaro', 'Iveta', 'Miro', 'Johnny'],
  'genders': ['m', 'm', 'f', 'm', 'f', 'm', 'm'],
  'owners': ['admin', 'admin', 'admin', 'admin', 'admin', 'admin', 'admin'],
};

var personList = <Person>[];
List<Map> personListJasonable = [];
List<String> mapKeys = persons.keys as List<String>;
void generatePersons() {
  for (var i = 0; i < persons['ids'].length; i++) {
    personList.add(Person(
      surname: persons['surnames'][i],
      gender: persons['genders'][i],
      owner: persons['owners'][i],
      name: persons['names'][i],
      id: persons['ids'][i],
    ));
    personListJasonable.add(personList[i].toJson());
  }
  print('Persons generated');
}
