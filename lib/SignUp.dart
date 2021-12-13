import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/SignIn.dart';
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget {
  @override
  State createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final keyForm = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      password2Controller = TextEditingController(),
      phoneNumController = TextEditingController(),
      nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
              child: Form(
            key: keyForm,
            child: Column(
              children: [
                Container(
                  height: 160,
                  child: Center(
                      child: Column(
                    children: [
                      Image.asset(
                        "images/breakfast.png",
                        fit: BoxFit.fitHeight,
                        height: 120,
                        width: 200,
                      ),
                      Text(
                        "User",
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
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                ),
                Container(
                  color: Color(0xFFF6F6F1),
                  height: 590,
                  child: Column(
                    children: [
                      nameInput(),
                      emailInput(),
                      phoneInput(),
                      passwordButton(passwordController),
                      passwordButton(password2Controller),
                      signUpButton(context),
                    ],
                  ),
                )
              ],
            ),
          )),
          color: Color(0xFFF6F6F1),
        ));
  }

  Widget nameInput() {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (name) {
          if (name!.isEmpty) {
            return "Enter your username";
          }
          return null;
        },
        controller: nameController,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: Icon(
            Icons.person,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your username",
        ),
      ),
    ));
  }

  Widget phoneInput() {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        validator: (phone) {
          String pattern = r'^\+?[0-9]{3}-?[0-9]{6,12}$';
          RegExp reg = RegExp(pattern);
          if (reg.hasMatch(phone!) == false) {
            return "Invalid phone number";
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        showCursor: true,
        controller: phoneNumController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: Icon(
            Icons.phone_android,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your phone number",
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        validator: (email) {
          final bool isValid = EmailValidator.validate(email!);
          if (isValid == false) {
            return "Invalid email format";
          }
          return null;
        },
        controller: emailController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: Icon(
            Icons.alternate_email,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your email",
        ),
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Widget passwordButton(TextEditingController control) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        validator: (password) {
          if (password!.isEmpty || password.length < 6) {
            return "Password should have at least 6 characters";
          }
          if (validateStructure(password) == false) {
            return "Password should have at least 1 big letter, 1 small letter, 1 cypher and 1 special character";
          }
          if (passwordController.value.text
                  .compareTo(password2Controller.value.text) !=
              0) {
            return "Passwords don't match";
          }
          return null;
        },
        obscureText: true,
        controller: control,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        showCursor: true,
        decoration: InputDecoration(
          errorMaxLines: 3,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          prefixIcon: Icon(
            Icons.password,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your password",
        ),
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 27, right: 15, left: 15),
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
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  String username = nameController.text.toString();
                  String email = emailController.text.toString();
                  String password = passwordController.text.toString();
                  String phone = phoneNumController.text.toString();
                  try {
                    Response response;
                    var dio = Dio();
                    response = await dio.post(
                        'https://food-care2.herokuapp.com/auth/register',
                        data: {
                          "name": username,
                          "email": email,
                          "password": password,
                          "phoneNumber": phone
                        });
                    if (response.statusCode == 200) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                      return;
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "Couldn't create account",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              }),
        ));
  }
}
