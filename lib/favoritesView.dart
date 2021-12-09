import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_care/restaurantView.dart';
//import 'package:geocoder/geocoder.dart';

import 'Business.dart';

class FavoritesView extends StatefulWidget {
  late List<Business> businessList;

  FavoritesView({required this.businessList});

  @override
  State createState() {
    return _FavoritesView(businessList: businessList);
  }
}

class _FavoritesView extends State<FavoritesView> {
  late List<Business> businessList;

  _FavoritesView({required this.businessList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, index) {
        return BusinessRow(business: businessList.elementAt(index));
      },
      itemCount: businessList.length,
    ));
  }
}

class BusinessRow extends StatelessWidget {
  Business business;
  BusinessRow({required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        )
      ]),
      child: Card(
        borderOnForeground: false,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            side: BorderSide(color: Colors.black.withOpacity(0.3))),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: InkWell(
              onTap: () async {
               /* final query = "${business.address.streetNumber} ${business.address.street}, ${business.address.city}";
                var addresses = await Geocoder.local.findAddressesFromQuery(query);
                var first = addresses.first;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        
                        builder: (context) => RestaurantView(
                              business: business, lat: first.coordinates.latitude, long: first.coordinates.longitude
                            )));
              */},
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: business.typeOfBusiness == BusinessType.RESTAURANT
                        ? Icon(Icons.restaurant)
                        : Icon(
                            Icons.shopping_basket,
                            size: 40,
                            color: Colors.amber,
                          ),
                    height: 100,
                    width: 110,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "${business.name}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "${business.address.country}, ${business.address.city} ${business.address.zipCode}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            " ${business.address.street} ${business.address.streetNumber}",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
