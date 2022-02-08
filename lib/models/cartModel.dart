import 'package:grocery_onlineapp/models/categoryProductModel.dart';

class Cart {
  String status;
  String message;
  int totalPrice;
  int totalMrp;
  int totalItems;
  int totalTax;
  int avgTax;
  int discountonmrp;
  List<Product> cartList = [];

  Cart();
  Cart.fromJson(Map<String, dynamic> json) {
    try {
      totalPrice = json['total_price'] != null ? double.parse(json['total_price'].toString()).round() : null;
      totalMrp = json['total_mrp'] != null ? double.parse(json['total_mrp'].toString()).round() : null;
      totalItems = json['total_items'] != null ? int.parse('${json['total_items']}') : null;
      totalTax = json['total_tax'] != null ? double.parse(json['total_tax'].toString()).round() : null;
      avgTax = json['avg_tax'] != null ? double.parse(json['avg_tax'].toString()).round() : null;
      discountonmrp = json['discountonmrp'] != null ? double.parse(json['discountonmrp'].toString()).round() : null;
      cartList = json['data'] != null ? List<Product>.from(json['data'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      print("Exception - cartModel.dart - Cart.fromJson():" + e.toString());
    }
  }
}
