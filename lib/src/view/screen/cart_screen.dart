import 'dart:convert';
import 'package:bitirme/src/view/screen/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/core/extensions.dart';
import 'package:bitirme/src/model/product.dart';
import 'package:bitirme/src/view/widget/empty_cart.dart';
import 'package:bitirme/src/controller/product_controller.dart';
import 'package:bitirme/src/view/animation/animated_switcher_wrapper.dart';
import 'package:bitirme/src/view/screen/payment_methods_screen.dart';
import 'package:bitirme/service/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

final ProductController controller = Get.put(ProductController());
final FirebaseAuth _auth = FirebaseAuth.instance;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String publishableKey =
      "pk_test_51Qc0Z5FsTMJbzVuHIS8tZL17mLNFhhUydweQll93uF3Gt46FAIBIAVuwWVrn1jRnEYJVlh9VPlMqfjzSJ6ML5dDY00M8chSssd";
  String secretKey =
      "sk_test_51Qc0Z5FsTMJbzVuHngTNhhxEGi6fQrefztu2T4KxgnS7I3IJ5TE7yQtFw8DHGafaEzeCKZ3yeDE0xejpYJA4FSdG00J2xZ2mZg";

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
      title: Text(
        "Sepetim",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.credit_card,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget cartList() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(controller.cartProducts.length, (index) {
          Product product = controller.cartProducts[index];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200]?.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ürün resmi
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      product.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Ürün bilgileri
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          controller.isPriceOff(product)
                              ? "\₺${product.discount}"
                              : "\₺${product.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Adet kontrolleri
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () =>
                            controller.decreaseItemQuantity(product),
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xFF33691E),
                          size: 20,
                        ),
                      ),
                      Obx(() => Text(
                            '${product.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )),
                      IconButton(
                        splashRadius: 10.0,
                        onPressed: () =>
                            controller.increaseItemQuantity(product),
                        icon: const Icon(
                          Icons.add,
                          color: Color(0xFF33691E),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Toplam",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          Obx(
            () {
              return AnimatedSwitcherWrapper(
                child: Text(
                  "\₺${controller.totalPrice.value}",
                  key: ValueKey<int>(controller.totalPrice.value),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF33691E),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget bottomBarButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
          ),
          onPressed: controller.isEmptyCart
              ? null
              : () async{
            if (_auth.currentUser == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lütfen önce giriş yapınız.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              await makePayment();
            }
          },
          child: const Text(
            "Şimdi Öde",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getCartItems();
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: !controller.isEmptyCart ? cartList() : const EmptyCart(),
          ),
          bottomBarTitle(),
          bottomBarButton()
        ],
      ),
    );
  }

  // Ödeme işlemi
  Future<void> makePayment() async {
    try {
      var paymentRequest = await createPaymentRequest();
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentRequest['client_secret'],
          merchantDisplayName: 'Modo Shop',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.green,
              background: Colors.white,
              componentBackground: Colors.grey[200],
            ),
          ),
        ),
      );
      await displayPaymentPage();
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ödeme başlatılamadı: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Ödeme sayfası
  Future<void> displayPaymentPage() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      final FirebaseService _firebaseService = FirebaseService();
      List<Map<String, dynamic>> urunListesi = [];

      for (var urun in controller.cartProducts) {
        urunListesi.add({
          'urunAdi': urun.name,
          'fiyat': urun.price.toDouble(),
          'adet': urun.quantity,
          'resim': urun.images[0],
        });
      }
      await _firebaseService.saveOrder(
          urunListesi, controller.totalPrice.value.toDouble());

      controller.clearCart();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Siparişiniz alındı!'),
          backgroundColor: Colors.green,),);}

    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Stripe ödeme isteği

  Future<Map<String, dynamic>> createPaymentRequest() async {
    try {
      var istek = {
        'amount': (controller.totalPrice.value * 100).toString(),
        'currency': 'TRY',
      };
      var cevap = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: istek,
      );
      return json.decode(cevap.body);
    } catch (e) {
      print('Hata: $e');
      throw Exception('Ödeme isteği oluşturulamadı');
    }
  }
}
