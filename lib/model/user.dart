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
  late String name, token;
  late String email, phoneNumber;
  late String password;
  late double latitude, longitude;

  User({required this.email, required this.name, required this.phoneNumber});
  //User({required this.email, required this.name, required this.phoneNumber, required this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber']);
    //  password: json['password']);
      
}
