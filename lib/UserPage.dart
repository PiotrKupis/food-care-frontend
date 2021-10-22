import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/PasswordChanger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainPage.dart';
import 'User.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends StatelessWidget{
  BuildContext previousOne;
  User user;
  UserPage(BuildContext context,User user){
    previousOne = context;
    this.user = user;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: UserPageWidget(context,user),
    );
  }
}

class UserPageWidget extends StatefulWidget{

  BuildContext previousOne;
  User user;
  UserPageWidget(BuildContext context, User user){
    previousOne = context;
    this.user = user;
  }

  @override
  _UserPageWidget createState() => _UserPageWidget(previousOne,user);
}

class _UserPageWidget extends State<UserPageWidget>{

  BuildContext previousOne;
  User user;
  var listOfFields = ["Username","E-mail","Change password"] ;
  var listOfAnswers = [];
  var listOfIcons = [];

  _UserPageWidget(BuildContext context,User user){
    previousOne = context;
    this.user = user;
    listOfAnswers.add(user.username);
    listOfAnswers.add(user.email);
    listOfAnswers.add("Change your password");
    listOfIcons.add(Icon(
      Icons.person,
      size: 32,
        color: Colors.white
    ));
    listOfIcons.add(Icon(
      Icons.email,
      size: 32,
      color: Colors.white
    ));
    listOfIcons.add(Icon(
        Icons.account_circle,
        size: 32,
        color: Colors.white
      )
    );
  }

  Future imageFromGallery() async{
    final picker = ImagePicker();
    final image = await  picker.getImage (
        source: ImageSource.gallery,
        imageQuality: 50
    );
    setState(() {
      if(image != null)
        MainPage.user.setImage(image);
        user.setImage(image);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SideDrawer(),
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              height: 250.0,
              child:Stack(
                children: [
                  Container(),
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      height: 230.0,
                      color: Colors.teal,
                    ),
                  ),
                  Align(
                      alignment: Alignment(0,1),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.tealAccent[400],
                              child: user.image == null
                                  ? Text(user.username,
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                  )
                                  : ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child:Image.file(
                                    new File(user.image.path),
                                    width:130,
                                    height: 130,
                                    fit: BoxFit.fitWidth,
                                  )
                              )
                            ),
                            FlatButton(
                                onPressed: imageFromGallery,
                                child: Icon(Icons.add_a_photo))
                          ]
                      )
                  ),
                  TopContent(),
                ],
              ),
            ),
            SizedBox(height: 25),
            CardItem(listOfFields[0], listOfAnswers[0], listOfIcons[0]),
            SizedBox(height: 5),
            CardItem(listOfFields[1], listOfAnswers[1], listOfIcons[1]),
            SizedBox(height: 5),
            InteractiveCardItem(listOfFields[2], listOfAnswers[2], listOfIcons[2],context,this.user),
          ],
        )
      )

    );
  }

  Widget TopContent(){
    return SafeArea(
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(previousOne);
              }
          ),
        ],
      ),
    );
  }



}

class MyCustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height-150);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
  
}


class InteractiveCardItem extends StatelessWidget{

  final String field, fieldFill;
  final Icon icon;
  final BuildContext previousOne;
  final User user;

  const InteractiveCardItem(this.field,this.fieldFill,this.icon,this.previousOne,this.user);

  Future<void> changePassword(BuildContext ctx, User user)async{
    await Navigator.push(ctx, MaterialPageRoute(builder: (context) => PasswordChanger(user: this.user, ctx: previousOne)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color:Colors.orangeAccent,
        child: InkWell(
          onTap: (){changePassword(previousOne, user);},
          child: Padding(
          padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 21,
          ),
          child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(width:24,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(field,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),),
                SizedBox(height:5),
                Text(fieldFill,
                  style: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                  ),
                ),
              ],
            )
          ],
        ),
        ),
        ),
      )
    );
  }
}


class CardItem extends StatelessWidget{

  final String field, fieldFill;
  final Icon icon;

  const CardItem(this.field,this.fieldFill,this.icon);
  

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding:EdgeInsets.symmetric(horizontal: 16),
        child: Card(
            color: Colors.orangeAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 21,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width:24,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(field,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height:5),
                      Text(fieldFill,
                        style: TextStyle(
                          fontFamily: GoogleFonts.openSans().fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ),
      );
  }

}