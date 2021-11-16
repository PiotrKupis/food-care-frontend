import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/addProductView.dart';
import 'package:food_care/editProductView.dart';

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
          )
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

  _ChangeData({required this.dataName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dataName),
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
      body: Center(
        child: Text(dataName),
      ),
    );
  }
}

/*class BusinessOffer extends StatefulWidget {
  @override
  State createState() => _BusinessOffer();
}

class _BusinessOffer extends State<BusinessOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Business offers"),
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
        body: Center(
          child: Column(
            children: [
              Text("Products list"),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProductView()));
                },
                child: Text("Edit"),
              )
            ],
          ),
        ));
  }

}*/
