import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Restaurant.dart';
import 'dart:async';
import 'SignUp.dart';
import 'MainPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'User.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  RestaurantsList.getRestaurants();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>{

  final keyForm = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showText = true;
  String name,email,pass,ID;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body:Form(
          key: keyForm,
          child: ListView(
            children: [Column(
                children: <Widget>[
                  Padding(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right:285,top: 55),
                        child: Text("E-mail",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:15,right: 15,top:5),
                          child: TextFormField(
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
                                Icons.account_circle,
                                size: 17,
                                color: Color(0xFF666666),
                              ),
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 17),
                              hintText: "Enter your e-mail",
                            ),
                            controller: username,
                            validator: (email){
                              if(email.isEmpty){
                                return "Fill e-mail field";
                              }
                              final bool isValid = EmailValidator.validate(email);
                              if(isValid == false){
                                return "Invalid email format";
                              }
                              return null;
                            },
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(right:265,top: 15),
                        child: Text("Password",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:15,right: 15,top:5),
                          child: TextFormField(
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
                              prefixIcon: IconButton(
                                icon: Icon(
                                  showText ? Icons.visibility : Icons.visibility_off,
                                  size: 17,
                                  color: Color(0xFF666666),
                                ),
                                onPressed: () {
                                  setState(() {
                                    showText = !showText;
                                  });
                                },
                              ),
                              fillColor: Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 17),
                              hintText: "Enter your password",
                            ),
                            obscureText: showText,
                            controller: password,
                            validator: (pass){
                              if(pass.isEmpty){
                                return "Fill password";
                              }
                              return null;
                            },
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15,right: 15,top:15),
                        child: SignInButton(context),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left:15,right: 15,top:15),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child:Text(
                                      "Don't have an account yet? ",
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.openSans().fontFamily,
                                      ),
                                    )
                                ),
                                InkWell(
                                    onTap: ()=>{register(context)},
                                    child:Container(
                                        child:Text(
                                          " Sign Up",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: GoogleFonts.openSans().fontFamily,
                                          ),
                                        )
                                    )
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                    padding: EdgeInsets.only(top:35),
                  )

                ]
            ),],
          ),
        )
    );
  }


  Future<void> register(context) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }
  Widget SignInButton(BuildContext context) {
    return Container(
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
              "SIGN IN",
              style: TextStyle(
                color:Colors.white,
                fontSize:25.0,
              ),
            )
        ),
        onPressed: () async{
          bool state = await checkSingIn();
          if(!state){
            return showDialog(context: context, builder: (ctx) =>
                AlertDialog(
                  title: Text("Ooops. Something went wrong"),
                  content: Text("User doesn't exist"),
                  actions: [
                    FlatButton(
                        onPressed: (){
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"))
                  ],
                )
            );
          }
          setState(()  {
            if(keyForm.currentState.validate()){
              goToSecondActivity(context, User(username: name,email:email,password: pass,ID: ID));
              }
          });
        },
      ),
    );
  }



  Future <bool> checkSingIn() async {
    List<User> list = await User.checkIfExist();
    if(list == null || list.isEmpty){
      return false;
    }
    User u = lookForUser(list, username.text.toString(), password.text.toString());
    if( u == null){
      return false;
    }
    name = u.username;
    email = u.email;
    pass = u.password;
    ID = u.ID;
    return true;
  }

  User lookForUser(List<User>usersList, String email, String password){
    for(int i = 0; i < usersList.length; i++){
      if(usersList.elementAt(i).email.compareTo(email) == 0
          && usersList.elementAt(i).password.compareTo(password) == 0){
          return usersList.elementAt(i);
      }
    }
    return null;
  }

  Future <void> goToSecondActivity(BuildContext context,User u) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(u)));
  }


}





