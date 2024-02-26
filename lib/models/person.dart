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
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        place: json["place"],
        gender: json["gender"],
        owner: json["owner"],
      );
}
