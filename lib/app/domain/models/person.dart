import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const Person._();

  const factory Person({
    int? id,
    String? surname,
    String? name,
    String? place,
    required String gender,
    required String owner,
  }) = _Person;

  factory Person.create({
    int? id,
    String? surname,
    String? name,
    String? place,
    String gender = '?',
    required String owner,
  }) =>
      Person(
        id: id,
        surname: surname,
        name: name,
        place: place,
        gender: gender,
        owner: owner,
      );
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

  /// Returns true if this person hasn't been saved to the database yet
  bool get isNew => id == null;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
