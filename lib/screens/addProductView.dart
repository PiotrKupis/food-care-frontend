import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_care/screens/MainPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductView extends StatefulWidget {
  @override
  State createState() => _AddProductView();
}

class _AddProductView extends State<AddProductView> {
  TextEditingController textEditingController = TextEditingController(),
      dateController = TextEditingController(),
      priceController = TextEditingController(),
      reducedPriceController = TextEditingController();
  final key = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late DateTime? expirationDate;
  late XFile? image;
  bool photoChosen = false;

  Widget errorIcon = Tooltip(
    height: 20,
    message: "No image chosen",
    child: Icon(
      Icons.error,
      color: Colors.red,
    ),
    textStyle: TextStyle(fontSize: 24),
  );
  String _selectedValue = "NORMAL";
  List<String> foodTypes = ["NORMAL", "VEGAN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: addProductForm(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget addProductForm() {
    return Center(
        child: Form(
      key: key,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          getField("Name", textEditingController),
          getPriceField("Normal Price", priceController),
          getPriceField("Price", reducedPriceController),
          getDateField("Expiration Date", context, dateController),
          getFoodType(),
          Padding(
            padding: EdgeInsets.only(top: 15, right: 25, left: 25, bottom: 10),
            child: Text(
              "Upload product photo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () async {
                  try {
                    image = await getImageFromGallery();
                    if (image != null) {
                      setState(() {
                        photoChosen = true;
                        errorIcon = Icon(
                          Icons.done,
                          color: Colors.green,
                        );
                      });
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.photo,
                      size: 32,
                    ),
                    Text("From gallery"),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () async {
                  image = await getImageFromCamera();
                  if (image != null) {
                    setState(() {
                      photoChosen = true;
                      errorIcon = Icon(
                        Icons.done,
                        color: Colors.green,
                      );
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_camera,
                      size: 32,
                    ),
                    Text("From camera")
                  ],
                ),
              ),
              errorIcon,
            ],
          ),
          addItem(),
        ],
      ),
    ));
  }

  Future<XFile?> getImageFromCamera() async {
    final XFile? pickedFile;
    try {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      return pickedFile;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<XFile?> getImageFromGallery() async {
    final XFile? pickedFile;
    try {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      return pickedFile;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget getField(String textfieldName, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        validator: (name) {
          if (name!.isEmpty) {
            return "Field is empty";
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
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your " + textfieldName,
        ),
      ),
    ));
  }

  Widget getPriceField(String textfieldName, TextEditingController controller) {
    return (Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (name) {
          if (name!.isEmpty) {
            return "Field is empty";
          }
          if (double.tryParse(name) != null) {
            return null;
          }
          return "Incorrect price";
        },
        controller: controller,
        showCursor: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your " + textfieldName,
        ),
      ),
    ));
  }

  Widget getFoodType() {
    return Padding(
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
          items: foodTypes.map((e) {
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
              _selectedValue = value as String;
            });
          },
          onSaved: (value) {
            setState(() {
              _selectedValue = value as String;
            });
          },
        ),
      ),
    );
  }

  Widget getDateField(
      textfieldName, context, TextEditingController dateController) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 5),
      child: TextFormField(
        validator: (input) {
          if (input!.isEmpty) {
            return "You need to choose date";
          }
          return null;
        },
        readOnly: true,
        onTap: () async {
          expirationDate = (await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 7))))!;
          if (expirationDate != null) {
            dateController.text = dateFormat.format(expirationDate!);
          }
        },
        controller: dateController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 4, style: BorderStyle.none)),
          filled: true,
          fillColor: Color(0xFFF2F3F5),
          hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 17),
          hintText: "Enter your " + textfieldName,
        ),
      ),
    );
  }

  Widget addItem() {
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
                    "ADD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  )),
              onPressed: () async {
                if (key.currentState!.validate() && photoChosen) {
                  String? name = textEditingController.value.text;
                  double? price = double.tryParse(priceController.value.text);
                  double? reducedPrice =
                      double.tryParse(reducedPriceController.value.text);
                  if (price != null && reducedPrice != null && image != null && reducedPrice > 1.99) {
                    try {
                      String date = expirationDate!.year.toString() +
                          "-" +
                          expirationDate!.month.toString() +
                          "-" +
                          expirationDate!.day.toString();
                      Response response;
                      final bytes = File(image!.path).readAsBytesSync();
                      String image64 =
                          "data:image/jpeg;base64," + base64Encode(bytes);
                      var dio = Dio();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? token = prefs.getString("token");
                      dio.options.headers["Authorization"] = '$token';
                      response = await dio.post(
                          "https://food-care2.herokuapp.com/product/add_product",
                          data: {
                            "name": name,
                            "regularPrice": price,
                            "discountedPrice": reducedPrice,
                            "expirationDate": date,
                            "vegan": _selectedValue.compareTo("NORMAL") == 0
                                ? false
                                : true,
                            "image": image64
                          });

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                  else{
                    Fluttertoast.showToast(
                        msg: "Price must be greater than 1.99",
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
