import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/core/app_data.dart';
import 'package:bitirme/core/app_color.dart';
import 'package:bitirme/src/controller/product_controller.dart';
import 'package:bitirme/src/view/widget/product_grid_view.dart';
import 'package:bitirme/src/view/widget/list_item_selector.dart';

enum AppbarActionType { leading, trailing }

final ProductController controller = Get.put(ProductController());

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  // Ana ekrandaki banner
  Widget _Banner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 170,
      decoration: BoxDecoration(
        color: AppData.recommendedProducts[0].cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Yılbaşına özel %10\nİNDİRİM!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Image.asset(
            AppData.recommendedProducts[0].imagePath,
            height: 130,
          ),
        ],
      ),
    );
  }
// Kategoriler yazısı
  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Kategoriler\n",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
// Filtrelenebilen kategoriler
  Widget _topCategoriesListView() {
    return ListItemSelector(
      categories: controller.categories,
      onItemPressed: (index) {
        controller.filterItemsByCategory(index);
      },
    );
  }
// Ekranımızın ana widgetı.
  @override
  Widget build(BuildContext context) {
    controller.getAllItems();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/home_modo1.png',
                  height: 60,
                  fit: BoxFit.contain,),),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Banner(context),
                    _topCategoriesHeader(context),
                    _topCategoriesListView(),
                    GetBuilder(builder: (ProductController controller) {
                      return ProductGridView(
                        items: controller.filteredProducts,
                        likeButtonPressed: (index) =>
                            controller.isFavorite(index),
                        isPriceOff: (product) => controller.isPriceOff(product),
                      );}),],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
