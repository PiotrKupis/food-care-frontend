import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/addProductView.dart';
import 'package:food_care/editProductView.dart';

class UserProfile extends StatefulWidget {
  @override
  State createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Name",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Name")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Email")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Phone number",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Phone number")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Password",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeData(dataName: "Password")));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Business",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BusinessAdd()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Business offers",
                    style: TextStyle(fontSize: 22),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusinessOffer()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: FlatButton(
                  minWidth: 250,
                  height: 55,
                  child: Text(
                    "Log out",
                    style: TextStyle(fontSize: 22),
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

class ChangeData extends StatefulWidget {
  String dataName;

  ChangeData({@required this.dataName});

  @override
  State createState() => _ChangeData(
        dataName: dataName,
      );
}

class _ChangeData extends State<ChangeData> {
  String dataName;

  _ChangeData({@required this.dataName});

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

class BusinessOffer extends StatefulWidget {
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
                          builder: (context) => AddProductView()));
                },
                child: Text("Add product"),
              ),
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
}
