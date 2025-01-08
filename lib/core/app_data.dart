import 'package:flutter/material.dart';
import 'package:bitirme/src/model/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme/src/model/product_category.dart';
import 'package:bitirme/src/model/recommended_product.dart';
import 'package:bitirme/src/model/bottom_nav_bar_item.dart';

class AppData {
  const AppData._();

  static const String currencySymbol = '₺';

  static List<Product> products = [
    Product(
      id: "1",
      name: 'Apple iPhone 16 Pro Max 256GB',
      price: 83000,
      isAvailable: true,
      off: 74700,
      quantity: 0,
      images: [
        'assets/images/apple_iphone_16_1.png',
        'assets/images/apple_iphone_16_2.png',
        'assets/images/apple_iphone_16_3.png',
      ],
      isFavorite: true,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      id: "2",
      name: 'Samsung Galaxy Tab S7 FE',
      price: 19999,
      isAvailable: false,
      off: 17999,
      quantity: 0,
      images: [
        'assets/images/tab_s7_fe_1.png',
        'assets/images/tab_s7_fe_2.png',
        'assets/images/tab_s7_fe_3.png',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.tablet,
    ),
    Product(
      id: "3",
      name: 'Samsung Galaxy Tab S8+',
      price: 27999,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/tab_s8_1.png',
        'assets/images/tab_s8_2.png',
        'assets/images/tab_s8_3.png',
      ],
      isFavorite: false,
      rating: 3,
      type: ProductType.tablet,
    ),
    Product(
      id: "4",
      name: 'APPLE Watch Series 10',
      price: 16799,
      isAvailable: true,
      off: 15120,
      quantity: 0,
      images: [
        'assets/images/apple_watch_1.png',
        'assets/images/apple_watch_1.1.png',
        'assets/images/apple_watch_1.3.png',
      ],
      isFavorite: false,
      rating: 5,
      type: ProductType.watch,
    ),
    Product(
      id: "5",
      name: 'APPLE Watch SE GPS 2024',
      price: 9999,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/apple_watch_2.png',
        'assets/images/apple_watch_2.1.png',
        'assets/images/apple_watch_2.3.png',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.watch,
    ),
    Product(
      id: "6",
      name: 'APPLE Airpods Max 2024',
      price: 7499,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/apple_airpods_max_1.png',
        'assets/images/apple_airpods_max_2.png',
        'assets/images/apple_airpods_max_3.png',
      ],
      isFavorite: false,
      rating: 2,
      type: ProductType.headphone,
    ),
    Product(
      id: "7",
      name: 'Apple AirPods Pro (2. Nesil)',
      price: 7499,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/apple_airpods_1.png',
        'assets/images/apple_airpods_1.2.png',
        'assets/images/apple_airpods_1.3.png',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.headphone,
    ),
    Product(
      id: "8",
      name: 'Vestel 43FA9740 43" 108 Ekran',
      price: 17599,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/vestel_1.png',
        'assets/images/vestel_2.png',
        'assets/images/vestel_3.png',
      ],
      isFavorite: false,
      rating: 3,
      type: ProductType.tv,
    ),
    Product(
      id: "9",
      name: 'LG OLEDB46 65 inç 165 cm 4K OLED Smart TV',
      price: 79999,
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/lg_1.png',
        'assets/images/lg_2.png',
        'assets/images/lg_3.png',
      ],
      isFavorite: false,
      rating: 2,
      type: ProductType.tv,
    ),
  ];

  static List<ProductCategory> categories = [
    ProductCategory(
      type: ProductType.all,
      icon: Icons.all_inclusive,
    ),
    ProductCategory(
      type: ProductType.mobile,
      icon: FontAwesomeIcons.mobileScreenButton,
    ),
    ProductCategory(
      type: ProductType.watch,
      icon: Icons.watch,
    ),
    ProductCategory(
      type: ProductType.tablet,
      icon: FontAwesomeIcons.tablet,
    ),
    ProductCategory(
      type: ProductType.headphone,
      icon: Icons.headphones,
    ),
    ProductCategory(
      type: ProductType.tv,
      icon: Icons.tv,
    ),
  ];

  static List<Color> randomColors = [
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFEDE7F6),
    const Color(0xFFE3F2FD),
    const Color(0xFFE0F2F1),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFECEFF1),
  ];

  static const Color lightGreen = Color.fromRGBO(34, 139, 34, 1.0);

  static List<BottomNavBarItem> bottomNavBarItems = [
    const BottomNavBarItem(
      "Ana Ekran",
      Icon(Icons.home),
    ),
    const BottomNavBarItem(
      "Favoriler",
      Icon(Icons.favorite),
    ),
    const BottomNavBarItem(
      "Sepet",
      Icon(Icons.shopping_cart),
    ),
    const BottomNavBarItem(
      "Profil",
      Icon(Icons.person),
    ),
  ];

  static List<RecommendedProduct> recommendedProducts = [
    RecommendedProduct(
      cardBackgroundColor: const Color.fromRGBO(10, 61, 51, 1.0),
    ),
  ];
}
