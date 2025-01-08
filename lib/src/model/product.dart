import 'package:bitirme/core/app_data.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

enum ProductType { all, watch, mobile, headphone, tablet, tv }

class Product {
  String id;
  String name;
  int price;
  int? off;
  String about = '';
  bool isAvailable;
  int _quantity;
  List<String> images;
  bool isFavorite;
  double rating;
  ProductType type;

  int get quantity => _quantity;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) _quantity = newQuantity;
  }

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.off,
    required int quantity,
    required this.images,
    required this.isFavorite,
    required this.rating,
    required this.type,
  }) : _quantity = quantity {
    loadAbout();
  }
// bir ürün oluşturulduğunda otomatik constructor calısıyor ve mu metodu cagırıyoruz
  //bu metot da olusturdugumuz json dosyasındaki verileri çekip about fieldına
  //atıyor
  Future<void> loadAbout() async {
    final String response =
        await rootBundle.loadString('assets/data/product_details.json');
    final Map<String, dynamic> data = json.decode(response);
    about = data[id]['about'];
  }
}
