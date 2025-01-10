import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/core/app_color.dart';
import 'package:bitirme/src/model/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme/src/view/widget/carousel_slider.dart';
import 'package:bitirme/src/controller/product_controller.dart';

final ProductController controller = Get.put(ProductController());

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {super.key});

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget productPageView(double width, double height) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: CarouselSlider(items: product.images),
    );
  }

  Widget _ratingBar(BuildContext context) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: product.rating,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const FaIcon(
            FontAwesomeIcons.solidStar,
            color: Colors.amber,
          ),
          onRatingUpdate: (_) {},
        ),
        Text(
          "(4500 Değerlendirme)",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w300,
              ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productPageView(width, height),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        _ratingBar(context),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              product.discount != null
                                  ? "\₺${product.discount}"
                                  : "\₺${product.price}",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(width: 3),
                            Visibility(
                              visible: product.discount != null ? true : false,
                              child: Text(
                                "\₺${product.price}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              product.isAvailable
                                  ? "Stok bulunuyor"
                                  : "Stok yok",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Ürün Hakkında",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(product.about),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: product.isAvailable
                                ? () => controller.addToCart(product)
                                : null,
                            child: const Text("Sepete Ekle"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
