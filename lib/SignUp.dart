import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'main.dart';
import 'User.dart';
import 'ApiKey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUp(),
    );
  }

}

class SignUp extends StatefulWidget{
  @override
  _SignUp createState()=> _SignUp();
}

class _SignUp extends State<SignUp>{

  String username,password,email;
  bool isChecked = false;
  final keyForm = GlobalKey<FormState>();
  TextEditingController usernameCon = TextEditingController(),
      passwordCon= TextEditingController(),verifyCon = TextEditingController(),
      emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: keyForm,
        child:ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nameInput(),
                emailInput(),
                passwordButton(passwordCon),
                passwordButton(verifyCon),
                checkBox(context),
                signUpButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(context: context, builder: (context){
        return AlertDialog(
        title: Text('Terms of use'),
        content:  ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '1. Use of Services.\n' +
                              '1.1. Android Things Console and Software. Subject to the Terms, Google grants you a limited, revocable, non-transferable, non-exclusive, right to (i) access and use the Android Things Console and (ii) install the Software on up to 100 devices per product owned or controlled by you for the sole purpose of internal development and testing of devices that have integrated the Software. These Terms do not provide you with a right to sell, exploit or otherwise distribute any device that has integrated the Software. If approved by Google, commercial rights to use the Software for these purposes must be granted expressly via a separate written agreement with Google ("Distribution Agreement"). The Distribution Agreement will control in the event of a conflict with these Terms.' +
                              '\n1.2. Developer Portal Credentials. You must have an Account to use the Android Things Console, and are responsible for the information provided to create the Account, the security of the passwords for the Account, and for any use of the Account, including allowing your End Users to use your Account. If you become aware of any unauthorized use of your password, your Account or the Services, you will notify Google as promptly as possible.' +
                              '\n1.3. End User Credentials. If you become aware of any unauthorized use of End User credentials to access the Android Things Console, you will notify Google as soon as you becomes aware of such unauthorized use.'+
                              '\n1.4. Security of Credentials For Third Party Services. If you become aware that an End User s credentials for third party services have been compromised, you, and not Google, will be solely responsible for notifying the third party service providers of the compromise according to the requirements imposed by those third party service providers. You understand that it is your responsibility to secure third party service credentials. You agree not to link third party service credentials to Google credentials.1.5 Restricted Access. Google services may be restricted from being made available in certain countries and regions'+
                              'Your Obligations.'+
                              '\n2.1. Privacy. You will comply with all Privacy Laws related to the processing of Customer Data, including by providing End Users with a legally adequate privacy notice prior to any collection of Customer Data that accurately discloses the collection, use, monitoring and disclosure of Customer Data by you and Google. You will obtain and maintain any consents from End Users required under Privacy Laws to permit the processing of Customer Data by you and Google. Further, you will notify End Users that Customer Data will be made available to a third party (i.e., Google) for the purposes described in Section 3.3. You will be solely responsible for ensuring that all collection, use and disclosure of Customer Data complies with all Privacy Laws.' +
                              '\n2.2. Restrictions. You will not, and will not allow third parties under your control to: (i) copy, modify, create a derivative work of, reverse engineer, decompile, translate, disassemble, or otherwise attempt to extract any or all of the source code of the Services (subject to Section 2.3 below and except to the extent such restriction is expressly prohibited by applicable law); (ii) use the Services for High Risk Activities; (iii) sublicense, resell, or distribute any or all of the Services; (iv) process or store any Customer Data that is subject to the International Traffic in Arms Regulations maintained by the Department of State.'+
                              '\n2.3. Third Party Components. Third-party components (which may include open source software) of the Services may be subject to separate license agreements. To the limited extent a third-party license expressly supersedes this Agreement, that third-party license instead governs your agreement with Google for the specific included third-party components of the Services, or use of the Services (as may be applicable).'+
                              '\n2.4. DMCA Policy. Google provides information to help copyright holders manage their intellectual property online, but Google cannot determine whether something is being used legally or not without their input. Google responds to notices of alleged copyright infringement and terminates accounts of repeat infringers according to the process set out in the U.S. Digital Millennium Copyright Act. If you think somebody is violating your or your End Users'+ 'copyrights and want to notify Google, you can find information about submitting notices, and Google s policy about responding to notices at http://www.google.com/dmca.html.'+

                              '\nTermination.'+

                              "\n3.1. Termination. You may stop using the Services at any time. You may terminate the Terms for convenience at any time on prior written notice and upon termination, must cease use of the Services. Google may terminate or suspend these Terms, including your right or ability to access or use the Services, for its convenience at any time without liability to you."+
                              "\n3.2. Effect of Termination. If these Terms are terminated, then: (i) the rights granted by one party to the other will immediately cease; (ii) you will delete the Software and any data you have provided that is accessible from within the Android Things Console."+
                              "Representations. Each party represents and warrants that: (i) it has full power and authority to enter into the Agreement; and (ii) it will comply with all laws and regulations applicable to its provision, or use, of the Services, as applicable."+
                              "Disclaimer. EXCEPT AS EXPRESSLY PROVIDED FOR HEREIN, TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, GOOGLE AND ITS SUPPLIERS DO NOT MAKE ANY OTHER WARRANTY OF ANY KIND, WHETHER EXPRESS, IMPLIED, STATUTORY OR OTHERWISE, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR USE AND NONINFRINGEMENT. GOOGLE AND ITS SUPPLIERS ARE NOT RESPONSIBLE OR LIABLE FOR THE DELETION OF OR FAILURE TO STORE ANY CUSTOMER DATA AND OTHER COMMUNICATIONS MAINTAINED OR TRANSMITTED THROUGH USE OF THE SERVICES. YOU ARE SOLELY RESPONSIBLE FOR SECURING AND BACKING UP YOUR DATA. NEITHER GOOGLE NOR ITS SUPPLIERS, WARRANTS THAT THE OPERATION OF THE SERVICES WILL BE ERROR-FREE OR UNINTERRUPTED. THE SERVICES ARE NOT DESIGNED, MANUFACTURED, OR INTENDED FOR HIGH RISK ACTIVITIES, AND AS SUCH YOU WILL NOT USE THE SERVICES FOR SUCH ACTIVITIES."+
                              "Limitation of Liability. WHEN PERMITTED BY LAW, GOOGLE, AND GOOGLE’S SUPPLIERS AND DISTRIBUTORS, WILL NOT BE RESPONSIBLE FOR LOST PROFITS, REVENUES, OR DATA, FINANCIAL LOSSES OR INDIRECT, SPECIAL, CONSEQUENTIAL, EXEMPLARY, OR PUNITIVE DAMAGES."+
                              "TO THE EXTENT PERMITTED BY LAW, THE TOTAL LIABILITY OF GOOGLE, AND ITS SUPPLIERS AND DISTRIBUTORS, FOR ANY CLAIMS UNDER THESE TERMS, INCLUDING FOR ANY IMPLIED WARRANTIES, IS LIMITED TO THE AMOUNT YOU PAID US TO USE THE SERVICES (OR, IF WE CHOOSE, TO SUPPLYING YOU THE SERVICES AGAIN)."+
                              "IN ALL CASES, GOOGLE, AND ITS SUPPLIERS AND DISTRIBUTORS, WILL NOT BE LIABLE FOR ANY LOSS OR DAMAGE THAT IS NOT REASONABLY FORESEEABLE."+
                              "Indemnification. Unless prohibited by applicable law, if you are a business or other legal entity, you will defend and indemnify Google, and its affiliates, directors, officers, employees, and users, against all claims, liabilities, damages, losses, costs, fees (including legal fees), and expenses relating to any allegation or third-party legal proceeding arising from: (i) your misuse, or your End User's misuse, of the Services, (ii) your violation, or your End User's violation, of the Terms; or (iii) any misuse of Customer Data, including any violation of Privacy Laws in connection with the processing of Customer Data."+
                              "Miscellaneous. We each agree to contract in the English language. If we provide a translation of the Terms, we do so for your convenience only and only the English language version of the Terms will be binding. The Terms do not create any third party beneficiary rights (unless the Terms expressly state that they do) or any agency, partnership, or joint venture. Nothing in the Terms will limit either party's ability to seek injunctive relief. We are not liable for failure or delay in performance to the extent caused by circumstances beyond our reasonable control. If you do not comply with the Terms, and Google does not take action right away, this does not mean that Google is giving up any rights that it may have (such as taking action in the future). If it turns out that a particular term is not enforceable, this will not affect any other terms. The Terms are the entire agreement between you and Google relating to its subject and supersede any prior or contemporaneous agreements on that subject. These Terms will not limit or supersede the terms of the Commercial Agreement. For information about how to contact Google, please visit our contact page. The laws of California, U.S.A., excluding California's conflict of laws rules, will apply to any disputes arising out of or related to the Terms and ALL CLAIMS ARISING OUT OF OR RELATING TO THE TERMS OR THE SERVICES WILL BE LITIGATED EXCLUSIVELY IN THE FEDERAL OR STATE COURTS OF SANTA CLARA COUNTY, CALIFORNIA, USA, AND YOU AND GOOGLE CONSENT TO PERSONAL JURISDICTION IN THOSE COURTS."

                      )
                    ],
                  ),
                ]
        ),
        actions: <Widget>[
        FlatButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text('CANCEL'),
            onPressed: () {
            setState(() {
            Navigator.pop(context);
            }
            );
        },
        ),
        ],
        );
        }
    );
  }

  Widget checkBox(BuildContext context){
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: isChecked,
          onChanged: (bool value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
        InkWell(
          child: Text("Click here to read Terms of use",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
          ),
          onTap: (){
            _displayTextInputDialog(context);
          },
        )
      ],
    );
  }


  Widget nameInput(){
    return(Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (name){
          if(name.isEmpty){
            return "Enter your username";
          }
          return null;
        },
        controller: usernameCon,
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
            Icons.person,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 17),
          hintText: "Enter your username",
        ),
      ),
    )
    );
  }




  Widget phoneInput(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        validator: (phone){
          Pattern pattern = r'^(\\d{3}[- .]?){2}\\d{4}$';
          RegExp reg = RegExp(pattern);
          if(reg.hasMatch(phone) == false){
            return "Invalid phone number";
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
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
            Icons.phone_android,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 17),
          hintText: "Enter your phone number",
        ),
      ),
    );
  }

  Widget emailInput(){
    return Padding(
      padding: EdgeInsets.only(left: 15,right: 15,top:15),
      child: TextFormField(
        validator: (email){
          final bool isValid = EmailValidator.validate(email);
          if(isValid == false){
            return "Invalid email format";
          }
          return null;
        },
        controller: emailCon,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
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
            Icons.email,
            size: 22,
            color: Color(0xFF666666),
          ),
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 17),
          hintText: "Enter your email",
        ),
      ),
    );
  }

  Widget passwordButton(TextEditingController control){
    return Padding(
      padding: EdgeInsets.only(left:15,right:15,top:15),
      child:TextFormField(
        validator: (password){
          if(password.isEmpty || password.length < 6){
            return "Password should have at least 6 characters";
          };
          if(passwordCon.value.text.compareTo(verifyCon.value.text) != 0){
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
          hintText: "Enter your password",
        ),
      ),
    );
  }

  Widget signUpButton(BuildContext context){
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
                  "SIGN UP",
                  style: TextStyle(
                    color:Colors.white,
                    fontSize:25.0,
                  ),
                )
            ),
            onPressed: ()=>
            {setState(() {
              if (keyForm.currentState.validate() && isChecked) {
                username = usernameCon.text.toString();
                email = emailCon.text.toString();
                password = passwordCon.text.toString();
                goToHome(this.context);
              }
              else{
                Fluttertoast.showToast(
                    msg: "Couldn't create account",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }),
            }),
      ),
    );
  }

  Future <void> goToHome(BuildContext context) async{
    try{
      SignUpUser sign = new SignUpUser(username, password,email);
      await sign.registerUser();
    } catch(error){
      print(error);
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}


class SignUpUser{
  User u;

  SignUpUser(String username, String password, String email){
    u = new User(username : username,password : password, email :email);
  }


  Future<void> registerUser() async{
      var url = Uri.parse(ApiKey.databaseUrl + "Users.json" ) ;
      var response;
      Map<String, String> headers = {"Content-type": "application/json"};
      try{
        response = await http.post(
            url,
            body: json.encode(
                {
                  "username" : u.username,
                  "email" : u.email,
                  "password" : u.password,
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
