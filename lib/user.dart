import 'package:email_validator/email_validator.dart';

enum type_t { USER, BUSINESS }

String convertUserType(type_t type) {
  if (type == type_t.BUSINESS) {
    return "BUSINESS";
  }
  return "USER";
}

type_t getUserType(String type) {
  if (type.compareTo("USER") == 0) {
    return type_t.USER;
  }
  return type_t.BUSINESS;
}

class User {
  String name, token;
  String email, phoneNumber;
  double latitude, longitude;

  User({this.email, this.name, this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber']);
}
