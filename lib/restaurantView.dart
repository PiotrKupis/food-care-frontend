import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_care/Business.dart';
import 'package:food_care/opinionView.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'RestaurantResults.dart';
import 'offerView.dart';

class RestaurantView extends StatefulWidget {

  late Business business;

  RestaurantView({required this.business});

  @override
  State<RestaurantView> createState() => _RestaurantViewState(business: business);
}

class _RestaurantViewState extends State<RestaurantView> {

  late Business business;
  
  _RestaurantViewState({required this.business});

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('id-1'), 
        position: LatLng(51.782423727644456, 19.452753383126257),
        infoWindow: InfoWindow(
          title: '${business.name}',
          snippet: '${business.openHour}-${business.closeHour}',)
        ));

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            decoration: BoxDecoration(
            //  border: Border(bottom: BorderSide(color: Colors.black)) ,
              color: Color(0xFFF2F3F5),
            ),
            child: Center(
              child: Text(
                business.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  ),
                ),
              
            )
          ),
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black)) ,
              color: Color(0xFFF2F3F5),
            ),
            child: Center(
              child: business.typeOfBusiness.index == 0 ? //tutaj poprawic
              Image.asset(
                  "images/shop.png",
                  fit: BoxFit.fitHeight,
                  height: 100,
                  width: 180,
              )
              : 
              Image.asset(
                  "images/restaurant-.png",
                  fit: BoxFit.fitHeight,
                  height: 100,
                  width: 180,
              )
              
            )
          ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
            //    border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child:
                Text(
                  "Open hours: " + business.openHour + " - " + business.closeHour,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    ),
                  ),   
            ),
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(5),
              height: 50,
              decoration: BoxDecoration(
            //    border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                        )
                  ),
               
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
           //     border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child:
                Text(
                  "Address: " + business.address.street + " " +
                  business.address.streetNumber + ", " + 
                  business.address.city,

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    ),
                  ),   
            ),
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(5),
              height: 50,
              decoration: BoxDecoration(
           //     border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OpinionView(),

                              ));
                  }, 
                  icon: Icon(
                            Icons.star,
                            color: Colors.yellow,
                        )
                  ),
               
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
             //   border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child:
                Text(
                  "Country: " + business.address.country,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    ),
                  ),   
            ),
            Container(
              //width: double.infinity,
              padding: EdgeInsets.all(5),
              height: 50,
              decoration: BoxDecoration(
             //   border: Border(bottom: BorderSide(color: Colors.black)) 
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfferView(),

                              ));
                  }, 
                  icon: Icon(
                            Icons.restaurant,
                            color: Colors.black,
                        )
                  ),
               
            ),
          ],
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: 50,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black)) 
          ),
          child:
          Text(
            "Opinion: ",
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 22,
              ),
            ),   
          ),
        Container(
          width: double.infinity,
          //padding: EdgeInsets.all(10),
          height: 350,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black)) 
          ),
          child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(51.782423727644456, 19.452753383126257),
                zoom: 15,
                ),
            )
          
          ),


        ],
      )
    );
  }
}

/*class RestaurantInfo extends StatefulWidget {
  @override
  State createState() {
    return _RestaurantInfo();
  }
}

class _RestaurantInfo extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text("Restaurant info: "),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OfferView()));
            },
            child: Text("Offer"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OpinionView()));
            },
            child: Text("Opinion"),
          )
        ],
      ),
    ));
  }
}*/
