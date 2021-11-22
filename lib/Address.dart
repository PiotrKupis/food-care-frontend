class Address {
  String country, city, zipCode, street, streetNumber;

  Address(
      {required this.country,
      required this.city,
      required this.zipCode,
      required this.streetNumber,
      required this.street});

  @override
  String toString() {
    return country +
        "\n" +
        city +
        ", " +
        zipCode +
        "\n" +
        street +
        " " +
        streetNumber;
  }
}
