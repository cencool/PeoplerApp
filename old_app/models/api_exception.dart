import 'dart:convert';

ApiException apiExceptionFromJson(String str) => ApiException.fromJson(json.decode(str));
String apiExceptionToJson(ApiException data) => json.encode(data.toJson());

class ApiException {
  String name;
  String message;
  int code;
  int status;
  String type;

  ApiException({
    required this.name,
    required this.message,
    required this.code,
    required this.status,
    required this.type,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) => ApiException(
        name: json["name"],
        message: json["message"],
        code: json["code"],
        status: json["status"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "message": message,
        "code": code,
        "status": status,
        "type": type,
      };
}
