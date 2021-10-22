import 'package:flutter/material.dart';
import 'ApiKey.dart';
import 'MainPage.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PasswordChanger extends StatelessWidget{

  User user;
  BuildContext ctx;

  PasswordChanger({@required this.user,@required this.ctx});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PasswordChangerWidget(user,context),
      );
  }
}

class PasswordChangerWidget extends StatefulWidget{

  User user;
  BuildContext ctx;
  PasswordChangerWidget(this.user,this.ctx);

  @override
  State createState() {
    return _PasswordChangerWidget(user,ctx);
  }
}

class _PasswordChangerWidget extends State<PasswordChangerWidget>{

  User user;
  BuildContext ctx;
  _PasswordChangerWidget(this.user,this.ctx);

  final keyForm = GlobalKey<FormState>();
  TextEditingController oldPassword = TextEditingController(),
      newPassword= TextEditingController(),newPassword2 = TextEditingController();

  Widget TopContent(){
    return SafeArea(
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(ctx);
              }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TopContent(),
        title: Text("Change password")
      ),
      body: Form(
        key:keyForm,
        child: ListView(
          children:[
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                oldPasswordFun(),
                newPasswordFun(),
                newPassword2Fun(),
                ChangeButton(context)
            ],
          ),
          ]
      ),
      )
    );
  }

  Widget oldPasswordFun(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:85),
      child: TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (oldPass){
            if(oldPass.isEmpty){
              return "Enter your old password";
            }
            if(oldPass.compareTo(user.password) != 0){
              return "This is not your old password";
            }
            return null;
          },
          controller: oldPassword,
          showCursor: true,
          decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none
              )
            ),
          filled: true,
          prefixIcon: Icon(
            Icons.lock,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontSize: 17),
          hintText: "Enter your old password",
          ),
        ),
      );
  }

  Widget newPasswordFun(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (newPass){
          if(newPass.isEmpty){
            return "Enter your new password";
          }
          if(newPassword.text.compareTo(newPassword2.text) != 0){
            return "Passwords don't match";
          }
          if(newPass.compareTo(user.password) == 0){
            return "This is your old password";
          }
          return null;
        },
        controller: newPassword,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none
              )
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.text_snippet,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 17),
          hintText: "Enter your new password",
        ),
      ),
    );
  }

  Widget newPassword2Fun(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (newPass2){
          if(newPass2.isEmpty){
            return "Confirm previous password";
          }
          if(newPassword.text.compareTo(newPassword2.text) != 0){
            return "Passwords don't match";
          }
          if(newPass2.compareTo(user.password) == 0){
            return "This is your old password";
          }
          return null;
        },
        controller: newPassword2,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none
              )
          ),
          filled: true,
          prefixIcon: Icon(
            Icons.text_snippet,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 17),
          hintText: "Confirm your new password",
        ),
      ),
    );
  }

  Future<bool> checkPassword() async{

    return true;
  }

  Widget ChangeButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child:Container(
        width:double.infinity,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xFFF44336)
              ),
              BoxShadow(
                  color: Color(0xFFFFA726)
              )
            ],
            gradient: new LinearGradient(
              colors:[Color(0xFFF44336), Color(0xFFFFA726)],
              begin: const FractionalOffset(0.2, 0.2),
              end: const FractionalOffset(1.0, 1.0),
              stops:[0.0,1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Color(0xFFf7418c),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 42.0),
                child:Text(
                  "CHANGE PASSWORD",
                  style: TextStyle(
                    color:Colors.white,
                    fontSize:21.0,
                  ),
                )
            ),
            onPressed: ()=>
            {setState(() {
              if(keyForm.currentState.validate()){
                  user.setPassword(newPassword.text.toString());
                  updateUser();
                  goToSecondActivity(context, user);
              }
            }),
            }),
      ),
    );
  }

  Future <void> goToSecondActivity(BuildContext context,User u) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(u)));
  }

  Future <void> updateUser() async{
    var url = Uri.parse(ApiKey.databaseUrl + "Users/" + user.ID + ".json") ;
    var response;
    Map<String, String> headers = {"Content-type": "application/json"};
    try{
      response = await http.put(
          url,
          body: json.encode(
              {
                "username" : user.username,
                "email" : user.email,
                "password" : user.password,
              }
          ),
          headers: headers
      );
      print(response.statusCode);
    } catch(error){
      print("Error when signing up: " + error);
      throw error;
    }
  }
}