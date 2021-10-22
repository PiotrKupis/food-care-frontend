import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'ApiKey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class User{
  String username;
  String email;
  String password;
  String ID;
  PickedFile image;

  User({@required this.username,@required this.email,@required this.password,this.ID});

  void setImage(PickedFile  img){
    image = img;
  }

  void setPassword(String password){
    this.password = password;
  }

  PickedFile getImage(){
    return image;
  }


  static Future<List<User>> checkIfExist() async{
    List<User>users  = [];
    try{
        var uri = Uri.parse(ApiKey.databaseUrl + "Users.json");
        final response =  await http.get(uri);
        final decodedData = json.decode(response.body) as Map<String,dynamic>;
        if(decodedData == null){
          print("Response body is null");
          throw NullThrownError();
        }
        decodedData.forEach((userID, user) {
          users.add(new User(
            ID:  userID,
            username: user['username'],
            email: user['email'],
            password: user ['password'],
          ));
        });
      }on SocketException catch (e){
        print('Socket Error: $e');
        throw e;
      }
      on Error catch(e){
        print("General Error: $e");
        throw e;
      }
      return users;
  }
}