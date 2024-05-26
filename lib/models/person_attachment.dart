import 'dart:convert';

List<PersonAttachment> personAttachmentFromJson(String str) =>
    List<PersonAttachment>.from(json.decode(str).map((x) => PersonAttachment.fromJson(x)));

String personAttachmentToJson(List<PersonAttachment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonAttachment {
  int id;
  int personId;
  String? fileCaption;
  String fileName;

  PersonAttachment({
    required this.id,
    required this.personId,
    this.fileCaption,
    required this.fileName,
  });

  factory PersonAttachment.fromJson(Map<String, dynamic> json) => PersonAttachment(
        id: json["id"],
        personId: json["person_id"],
        fileCaption: json["file_caption"],
        fileName: json["file_name"],
      );

  factory PersonAttachment.dummySearch() =>
      PersonAttachment(id: -1, personId: -1, fileName: '', fileCaption: '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "file_caption": fileCaption,
        "file_name": fileName,
      };
}
