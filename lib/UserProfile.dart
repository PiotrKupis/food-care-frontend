import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/addProductView.dart';
import 'package:food_care/editProductView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';
import 'user.dart';

class UserProfile extends StatefulWidget {
 
  @override
  State createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  static Widget getLogoScreen(String text) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: Center(
          child: Column(
        children: [
          Image.asset(
            "images/breakfast.png",
            fit: BoxFit.fitHeight,
            height: 100,
            width: 180,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 120, right: 120),
            child: Divider(
              color: Colors.red,
              height: 5,
              thickness: 2,
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              getLogoScreen("Edit Profile"),
              editNameButton(context),
              editPhoneNumberButton(context),
              editEmailButton(context),
              editPasswordButton(context),           
            ],
          )
        ],
      ),
    );
  }

  Widget editNameButton(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Color(0xFFf7418c),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Name")));
                  }, 
              ),
        ));
  }
  Widget editPhoneNumberButton(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Color(0xFFf7418c),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Phone Number")));
                  }, 
              ),
        ));
  }

  Widget editEmailButton(BuildContext context){
    return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Color(0xFFf7418c),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Email")));
                  }, 
              ),
        ));
  }
  Widget editPasswordButton(BuildContext context){
     return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15, bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Color(0xFFf7418c),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Password")));
                  }, 
              ),
        ));
  }
}

class ChangeData extends StatefulWidget {
  String dataName;

  ChangeData({required this.dataName});
  

  @override
  State createState() => _ChangeData(
        dataName: dataName,
      );
}

class _ChangeData extends State<ChangeData> {
  String dataName;

  TextEditingController nameController = TextEditingController();
  TextEditingController newPassword = TextEditingController(), newPassword2 = TextEditingController();

  
  _ChangeData({required this.dataName});

  final keyForm = GlobalKey<FormState>();

  

  static Widget getLogoScreen(String text) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: Center(
          child: Column(
        children: [
          Image.asset(
            "images/breakfast.png",
            fit: BoxFit.fitHeight,
            height: 100,
            width: 180,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 120, right: 120),
            child: Divider(
              color: Colors.red,
              height: 5,
              thickness: 2,
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Form(
              key: keyForm,
              child: ListView(
                children: [
                  getLogoScreen(dataName),
                  if (dataName == "Name") ...[
                     nameInput(
                      dataName,
                      Icon(
                        Icons.person,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      nameController),
                  ] else if (dataName == "Email")...[
                      nameInput(
                      dataName,
                      Icon(
                        Icons.email,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      nameController),
                  ]
                  else if (dataName == "Phone Number")...[
                      nameInput(
                      dataName,
                      Icon(
                        Icons.phone,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      nameController),
                  ]
                  else if (dataName == "Password")...[
                     newPasswordWidget(),
                     confirmPasswordWidget(),
                     
                  ],
                  confirmButton(),
                ],
              ),
            ),
          )
          //getLogoScreen(dataName),
        ],
      )
    );
  }

 

  Widget confirmButton() {
    return Padding(
        padding: EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 5),
        child: Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xFFF44336)),
                BoxShadow(color: Color(0xFFFFA726))
              ],
              gradient: new LinearGradient(
                colors: [Color(0xFFF44336), Color(0xFFFFA726)],
                begin: const FractionalOffset(0.2, 0.2),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
          child: MaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Color(0xFFf7418c),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  try{
                    String name = nameController.value.text;
                    Response response;
                    var dio = Dio();
                    SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                    String? token = prefs.getString("token");
                    dio.options.headers["Authorization"] = '$token';
                    response = await dio
                              .get("https://food-care2.herokuapp.com/user");
                    User user = User.fromJson(response.data);
                    debugPrint(user.email);
                    debugPrint(user.name);
                    debugPrint(user.phoneNumber);
                  /*  Map<String, dynamic> map = response.data;
                    String? password = map.values.elementAt(2);
                    print(password);*/
                   // debugPrint(user.password);
                    if(dataName == "Name"){
                      try {
                        var dio = Dio();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        dio.options.headers["Authorization"] = '${token}';
                        response = await dio.post(
                          'https://food-care2.herokuapp.com/user',
                          data: {
                            "name": name,
                          }
                        );
                        if(response.statusCode == 200){
                          User user = User.fromJson(response.data);
                          debugPrint(user.name);
                          Fluttertoast.showToast(
                              msg: "Successfully confirmed " + dataName.toLowerCase(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                          print(e);
                          Fluttertoast.showToast(
                              msg: "Couldn't change " + dataName,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }
                    }
                    else if(dataName == "Email"){
                       try {
                        var dio = Dio();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        dio.options.headers["Authorization"] = '${token}';
                        response = await dio.post(
                          'https://food-care2.herokuapp.com/user',
                          data: {
                            "email": name,
                          }
                        );
                        if(response.statusCode == 200){
                          User user = User.fromJson(response.data);
                          debugPrint(user.email);
                          Fluttertoast.showToast(
                              msg: "Successfully confirmed " + dataName.toLowerCase(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                          print(e);
                          Fluttertoast.showToast(
                              msg: "Couldn't change " + dataName,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }  
                    }
                    else if(dataName == "Phone Number"){
                       try {
                        var dio = Dio();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        dio.options.headers["Authorization"] = '${token}';
                        response = await dio.post(
                          'https://food-care2.herokuapp.com/user',
                          data: {
                            "phoneNumber": name,
                          }
                        );
                        if(response.statusCode == 200){
                          User user = User.fromJson(response.data);
                          debugPrint(user.phoneNumber);
                          Fluttertoast.showToast(
                              msg: "Successfully confirmed " + dataName.toLowerCase(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                          print(e);
                          Fluttertoast.showToast(
                              msg: "Couldn't change " + dataName,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }
                    }
                    else if(dataName == "Password"){
                      try {
                        String pass2 = newPassword2.value.text;
                        var dio = Dio();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        dio.options.headers["Authorization"] = '${token}';
                        response = await dio.post(
                          'https://food-care2.herokuapp.com/user',
                          data: {
                            "password": pass2,
                          }
                        );
                        if(response.statusCode == 200){
                          User user = User.fromJson(response.data);
                          //debugPrint(user.phoneNumber);
                          Fluttertoast.showToast(
                              msg: "Successfully confirmed " + dataName.toLowerCase(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                          print(e);
                          Fluttertoast.showToast(
                              msg: "Couldn't change " + dataName,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }
                    }
                  }
                  catch(e){
                    debugPrint(e.toString());
                  }
                  
                
                }
              }),
        ));
  }

   Widget newPasswordWidget(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        obscureText: true,
        validator: (newPass){
          if(newPass!.isEmpty){
            return "Enter your new password";
          }
          if(newPassword.text.compareTo(newPassword2.text) != 0){
            return "Passwords don't match";
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

  Widget confirmPasswordWidget(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        obscureText: true,
        validator: (newPass2){
          if(newPass2!.isEmpty){
            return "Confirm previous password";
          }
          if(newPassword.text.compareTo(newPassword2.text) != 0){
            return "Passwords don't match";
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
}


Widget nameInput(
      String textfieldName, Icon icon, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        validator: (name) {
          if (name!.isEmpty) {
            return "Field is empty";
          }
          if (textfieldName.compareTo("Phone Number") == 0) {
            String pattern = r'^\+?[0-9]{3}-?[0-9]{6,12}$';
            RegExp reg = RegExp(pattern);
            if (reg.hasMatch(name) == false) {
              return "Invalid phone number";
            }
          }
          if (textfieldName.compareTo("Email") == 0) {
            final bool isValid = EmailValidator.validate(name);
            if (isValid == false) {
              return "Invalid email format";
            }
          }
          return null;
        },
        controller: controller,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: icon,
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your new " + textfieldName.toLowerCase(),
        ),
      ),
    ));
  }

