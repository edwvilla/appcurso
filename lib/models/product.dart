// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productsFromJson(List list) =>
    list.map<Product>((p) => Product.fromJson(p)).toList();

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final int id;
  final Attributes attributes;

  Product({
    required this.id,
    required this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };

  @override
  String toString() {
    return 'Product{id: $id, name: ${attributes.name}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.id == id;
  }
}

class Attributes {
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final Details details;
  final String description;
  final String brand;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  Attributes({
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.details,
    required this.description,
    required this.brand,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        price: json["price"].toDouble(),
        rating: json["rating"]?.toDouble(),
        imageUrl: json["imageUrl"],
        details: Details.fromJson(json["details"]),
        description: json["description"],
        brand: json["brand"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "rating": rating,
        "imageUrl": imageUrl,
        "details": details.toJson(),
        "description": description,
        "brand": brand,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}

class Details {
  final List<double> sizes;

  Details({
    required this.sizes,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        sizes: List<double>.from(json["sizes"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "sizes": List<dynamic>.from(sizes.map((x) => x)),
      };
}
