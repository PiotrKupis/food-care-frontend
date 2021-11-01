import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';

class UserProfile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Food Care",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: UserProfileWidget(),
    );
  }
}



class UserProfileWidget extends StatefulWidget{

  @override
  State createState() {
    return _UserProfileWidget();
  }
}

class _UserProfileWidget extends State<UserProfileWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Name",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeData(dataName: "Name")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Email",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeData(dataName: "Email")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Phone number",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeData(dataName: "Phone number")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Password",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeData(dataName: "Password")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Business",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessAdd()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Business offers",
                    style: TextStyle(
                      fontSize: 22
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeData(dataName: "Business offers")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text("Log out",
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  onPressed: () {},
                  shape: OutlineInputBorder(),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class ChangeData extends StatelessWidget{

  String dataName;

  ChangeData({@required this.dataName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Food Care",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeDataWidget(dataName: dataName,),
    );
  }
}


class ChangeDataWidget extends StatefulWidget{

  String dataName;

  ChangeDataWidget({@required this.dataName});

  @override
  State createState() {
    return _ChangeDataWidget(dataName: dataName);
  }
}


class _ChangeDataWidget extends State<ChangeDataWidget>{

  String dataName;

  _ChangeDataWidget({@required this.dataName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(dataName),
      ),
    );
  }
}