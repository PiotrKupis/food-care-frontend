class Product {
  late String name, expirationDate, image;
  late double regularPrice, discountedPrice;
  late bool isVegan;
  late int id, ownerId;

  Product(
      {required this.name,
      required this.expirationDate,
      required this.image,
      required this.regularPrice,
      required this.discountedPrice,
      required this.isVegan,
      required this.id,
      required this.ownerId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      ownerId: json["ownerId"],
      name: json['name'],
      regularPrice: json['regularPrice'],
      discountedPrice: json['discountedPrice'],
      expirationDate: json['expirationDate'],
      isVegan: json['vegan'],
      image: json['linkToResource'],
    );
  }
}
