import 'package:flutter/material.dart';

class Offer{

  int id,restaurantID;
  String name;
  Image image;
  double oldPrice, newPrice;
  DateTime creationDate,expirationDate;

  Offer({required this.name,required this.id,required this.restaurantID,
    required this.image, required this.oldPrice, required this.newPrice,
    required this.creationDate, required this.expirationDate
  });

}

class OfferScroolContent extends StatelessWidget{

  late Offer offer;

  OfferScrollContent(Offer offer){
    this.offer = offer;
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
                            child: offer.image != null ? offer.image :
                            Image.asset("images/no_image.jpg",width: 120,height: 120,)
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(top:10,left:10),
                          child: Text(offer.name + " "  + offer.newPrice.toString() +"zl",
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