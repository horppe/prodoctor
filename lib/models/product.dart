import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType()
class Product {


  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  double quantity;

  @HiveField(4)
  String userId;

  Product({this.id, this.name, this.price, this.quantity, this.userId});

  factory Product.fromSnapshot(DocumentSnapshot document) {
    
    document.data.entries.forEach((ent) => print(ent.key));
    return Product(
      id: document.documentID,
      name: document["name"].toString(), 
      price: double.parse(document["price"].toString()), 
      quantity: double.parse(document["quantity"].toString()),
      userId: document["userId"].toString()
    );
  }

}