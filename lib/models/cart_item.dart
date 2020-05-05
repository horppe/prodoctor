
import 'package:flutter/material.dart';

class CartItem {
  String name;
  String id;
  String productId;
  String quantity;
  String price;

  CartItem({@required this.id, @required this.productId, @required this.name, this.quantity, this.price});

}