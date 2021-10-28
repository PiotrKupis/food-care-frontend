import 'package:flutter/material.dart';
import 'package:food_care/Address.dart';

class Business{

  int id;
  Address address;
  String typeOfBusiness;
  DateTime openHour,closeHour;

  Business({@required this.id,@required this.address,
    @required this.typeOfBusiness, @required this.openHour, @required this.closeHour,
  });

}

class BusinessScrollContent extends StatelessWidget{

  Business business;

  BusinessScrollContent(Business business){
    this.business = business;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Column(
        children: [
          Container(
            child: Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
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
                            padding: EdgeInsets.only(left:5,right:5),
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
                          padding: EdgeInsets.only(left:10,top:10),
                          child:  Image.asset("images/no_image.jpg",width: 120,height: 120,)
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(top:10,left:10),
                          child: Text(business.address.city + "," + business.address.street
                            + " " + business.address.streetNumber,
                            style: TextStyle(
                                color: Color(0xFF6e6e71),
                                fontSize: 13,
                                fontWeight: FontWeight.w400
                            ),
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