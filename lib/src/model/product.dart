import 'package:bitirme/core/app_data.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:get/get.dart';

enum ProductType { all, watch, mobile, headphone, tablet, tv }

class Product {
  String id;
  String name;
  int price;
  int? discount;
  String about = '';
  bool isAvailable;
  final RxInt _quantity = 0.obs;
  List<String> images;
  bool isFavorite;
  double rating;
  ProductType type;

  int get quantity => _quantity.value;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) _quantity.value = newQuantity;
  }

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.discount,
    required int quantity,
    required this.images,
    required this.isFavorite,
    required this.rating,
    required this.type,
  }) {
    _quantity.value = quantity;
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
