import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/MainPage.dart';
import 'package:food_care/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class SignIn extends StatefulWidget {
  @override
  State createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final keyForm = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
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
                      emailInput(),
                      passwordButton(passwordController),
                      SignInButton(context),
                    ],
                  ),
                )
              ],
            ),
          )),
          color: Color(0xFFF6F6F1),
        ));
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

  Widget passwordButton(TextEditingController control) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: TextFormField(
        validator: (password) {
          if (password!.isEmpty || password.length < 6) {
            return "Password should have at least 6 characters";
          }
          return null;
        },
        obscureText: true,
        controller: control,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        showCursor: true,
        decoration: InputDecoration(
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

  Widget SignInButton(BuildContext buildContext) {
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
                    "SIGN IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  String email = emailController.text.toString();
                  String password = passwordController.text.toString();
                  try {
                    Response response;
                    var dio = Dio();
                    response = await dio.post(
                        'https://food-care2.herokuapp.com/auth/login',
                        data: {
                          "email": email,
                          "password": password,
                        });
                    if (response.statusCode == 200) {
                      Map<String, dynamic> map = response.data;
                      int id = map.values.elementAt(0);
                      String e = map.values.elementAt(1);
                      String role = map.values.elementAt(3);
                      print(role);
                      try {
                        Position position = await _determinePosition();
                        dio.options.headers["Authorization"] = '${e}';
                        response = await dio
                            .get("https://food-care2.herokuapp.com/user");
                        User user = User.fromJson(response.data);
                        user.token = e;
                        user.latitude = position.latitude;
                        user.longitude = position.longitude;
                        setUser(user, e, role, id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                      } catch (e) {
                        debugPrint(e.toString());
                      }

                      return;
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "You could not be logged in",
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permisssions ade disabled forever");
    }
    return await Geolocator.getCurrentPosition();
  }

  void setUser(User user, String token, String role, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userDetails = [];
    userDetails.add(user.email);
    userDetails.add(user.name);
    userDetails.add(user.phoneNumber);
    userDetails.add(user.latitude.toString());
    userDetails.add(user.longitude.toString());
    await prefs.setStringList("userDescription", userDetails);
    await prefs.setString("role", role);
    await prefs.setString("token", token);
    await prefs.setInt("id", id);
  }
}
