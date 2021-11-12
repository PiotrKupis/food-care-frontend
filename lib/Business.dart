import 'package:flutter/material.dart';
import 'package:food_care/Address.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/MainPage.dart';
import 'package:food_care/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BusinessType {
  SHOP,
  RESTAURANT,
}

class Business {
  String name, email, phone;
  Address address;
  BusinessType typeOfBusiness;
  String openHour, closeHour;

  Business({
    @required this.name,
    @required this.address,
    @required this.typeOfBusiness,
    @required this.openHour,
    @required this.closeHour,
    @required this.email,
    @required this.phone,
  });

  static BusinessType getValue(String name) {
    if (name.compareTo("SHOP") == 0) {
      return BusinessType.SHOP;
    }
    return BusinessType.RESTAURANT;
  }

  static String convertValue(BusinessType type) {
    if (type == BusinessType.RESTAURANT) {
      return "RESTAURANT";
    }
    return "SHOP";
  }
}

class BusinessScrollContent extends StatelessWidget {
  Business business;

  BusinessScrollContent(Business business) {
    this.business = business;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Container(
                width: 150,
                height: 150,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            alignment: Alignment.topRight,
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFfae3e2),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Image.asset(
                              "images/no_image.jpg",
                              width: 120,
                              height: 120,
                            )),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            business.address.city +
                                "," +
                                business.address.street +
                                " " +
                                business.address.streetNumber,
                            style: TextStyle(
                                color: Color(0xFF6e6e71),
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BusinessAdd extends StatefulWidget {
  @override
  State createState() {
    return _BusinessAdd();
  }
}

class _BusinessAdd extends State<BusinessAdd> {
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      typeController = TextEditingController(),
      openHourController = TextEditingController(),
      closeHourController = TextEditingController();

  final keyForm = GlobalKey<FormState>();

  List<String> businessTypes = ["SHOP", "RESTAURANT"];
  String _selectedValue = "SHOP";

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
                  getLogoScreen("Business"),
                  nameInput(
                      "Name",
                      Icon(
                        Icons.person,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      nameController),
                  nameInput(
                      "E-mail",
                      Icon(
                        Icons.alternate_email,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      emailController),
                  nameInput(
                      "Phone number",
                      Icon(
                        Icons.phone,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      phoneController),
                  typeInput(
                      "Type",
                      Icon(
                        Icons.shop,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      typeController),
                  dateInput(
                      "Open hour",
                      Icon(
                        Icons.hourglass_top,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      openHourController),
                  dateInput(
                      "Close hour",
                      Icon(
                        Icons.hourglass_bottom,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      closeHourController),
                  completeForm(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget nameInput(
      String textfieldName, Icon icon, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        validator: (name) {
          if (name.isEmpty) {
            return "Field is empty";
          }
          if (textfieldName.compareTo("Phone number") == 0) {
            Pattern pattern = r'^\+?[0-9]{3}-?[0-9]{6,12}$';
            RegExp reg = RegExp(pattern);
            if (reg.hasMatch(name) == false) {
              return "Invalid phone number";
            }
          }
          if (textfieldName.compareTo("E-mail") == 0) {
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
          hintText: "Enter your " + textfieldName,
        ),
      ),
    ));
  }

  Widget typeInput(
      String textfieldName, Icon icon, TextEditingController controller) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
          child: InputDecorator(
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.black, fontSize: 12.0),
              hintText: 'Please select option',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 4, style: BorderStyle.none),
              ),
            ),
            child: DropdownButtonFormField(
              items: businessTypes.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  value: e,
                );
              }).toList(),
              isExpanded: true,
              value: _selectedValue,
              hint: Text("Choose"),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget dateInput(
      String textfieldName, Icon icon, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        textInputAction: TextInputAction.next,
        validator: (name) {
          if (name.isEmpty) {
            return "Field is empty";
          }
          Pattern pattern = r'^\d{1,2}:\d{2}$';
          RegExp reg = RegExp(pattern);
          if (reg.hasMatch(name) == false) {
            return "Invalid date format {XX:XX}";
          }
          return null;
        },
        onTap: () {},
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
          hintText: "Enter your " + textfieldName,
        ),
      ),
    ));
  }

  Widget completeForm(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
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
                    "NEXT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (keyForm.currentState.validate()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessWidgetFormComplete(
                                type: Business.getValue(_selectedValue),
                                closeHour: closeHourController.value.text,
                                openHour: openHourController.value.text,
                                email: emailController.value.text,
                                name: nameController.value.text,
                                phone: phoneController.value.text,
                              )));
                }
              }),
        ));
  }
}

class BusinessWidgetFormComplete extends StatefulWidget {
  final String name, email, phone, openHour, closeHour;
  BusinessType type;

  BusinessWidgetFormComplete(
      {@required this.name,
      @required this.email,
      @required this.phone,
      @required this.openHour,
      @required this.closeHour,
      @required this.type});

  @override
  State createState() {
    return _BusinessWidgetFormComplete(
        name: name,
        email: email,
        phone: phone,
        openHour: openHour,
        closeHour: closeHour,
        type: type);
  }
}

class _BusinessWidgetFormComplete extends State<BusinessWidgetFormComplete> {
  TextEditingController streetController = TextEditingController(),
      streetNumberController = TextEditingController(),
      countryController = TextEditingController(),
      codeController = TextEditingController(),
      cityController = TextEditingController();

  final keyForm = GlobalKey<FormState>();

  final String name, email, phone, openHour, closeHour;
  BusinessType type;

  _BusinessWidgetFormComplete(
      {@required this.name,
      @required this.email,
      @required this.phone,
      @required this.openHour,
      @required this.closeHour,
      @required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _BusinessAdd.getLogoScreen("Business"),
          Expanded(
            flex: 1,
            child: Form(
              key: keyForm,
              child: ListView(
                children: [
                  nameInput(
                      "Country",
                      Icon(
                        Icons.flag,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      countryController),
                  nameInput(
                      "Zip code",
                      Icon(
                        Icons.code,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      codeController),
                  nameInput(
                      "City",
                      Icon(
                        Icons.location_city,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      cityController),
                  nameInput(
                      "Street",
                      Icon(
                        Icons.home,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      streetController),
                  nameInput(
                      "Street number",
                      Icon(
                        Icons.home_work,
                        size: 22,
                        color: Color(0xFF666666),
                      ),
                      streetNumberController),
                  addBusiness(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget nameInput(
      String textfieldName, Icon icon, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        validator: (name) {
          if (name.isEmpty) {
            return "Field is empty";
          }
          if (textfieldName.compareTo("Phone number") == 0) {
            Pattern pattern = r'^\+?[0-9]{3}-?[0-9]{6,12}$';
            RegExp reg = RegExp(pattern);
            if (reg.hasMatch(name) == false) {
              return "Invalid phone number";
            }
          }
          if (textfieldName.compareTo("E-mail") == 0) {
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
          hintText: "Enter your " + textfieldName,
        ),
      ),
    ));
  }

  Widget addBusiness(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 5),
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
                    "ADD BUSINESS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (keyForm.currentState.validate()) {
                  String country = countryController.value.text;
                  String code = codeController.value.text;
                  String street = streetController.value.text;
                  String number = streetNumberController.value.text;
                  String city = cityController.value.text;
                  Address address = Address(
                    city: city,
                    country: country,
                    street: street,
                    streetNumber: number,
                    zipCode: code,
                  );
                  Business business = Business(
                    address: address,
                    closeHour: closeHour,
                    name: name,
                    openHour: openHour,
                    typeOfBusiness: type,
                    email: email,
                    phone: phone,
                  );
                  Response response;
                  try {
                    var dio = Dio();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String token = prefs.getString("token");
                    dio.options.headers["Authorization"] = '${token}';
                    response = await dio.post(
                      'https://food-care2.herokuapp.com/business',
                      data: {
                        "name": business.name,
                        "country": business.address.country,
                        "city": business.address.city,
                        "zipCode": business.address.zipCode,
                        "street": business.address.street,
                        "streetNumber": business.address.streetNumber,
                        "email": business.email,
                        "phoneNumber": business.phone,
                        "businessType":
                            Business.convertValue(business.typeOfBusiness),
                        "openHour": business.openHour,
                        "closeHour": business.closeHour
                      },
                    );
                    if (response.statusCode == 200) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                      return;
                    }
                  } catch (e) {
                    print(e);
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
