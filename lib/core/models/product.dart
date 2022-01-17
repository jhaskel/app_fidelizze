
import 'dart:convert';
import 'dart:convert' as convert;




class Product {
   String id;
   String name;
   String description;
   double price;
   String imageUrl;
  bool isFavorite;

  Product({
     required this.id,
     required this.name,
     required this.description,
     required this.price,
     required this.imageUrl,
    this.isFavorite = false,
  });


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    isFavorite: json["isFavorite"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "imageUrl": imageUrl,
    "isFavorite": isFavorite,
  };


  @override
  String toString() {
    return 'Product{id: $id, nome: $name, icone: $price}';
  }

}
