import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:bitirme/core/app_data.dart';
import 'package:bitirme/src/model/product.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:bitirme/src/model/product_category.dart';

class ProductController extends GetxController {
  List<Product> allProducts = AppData.products;
  RxList<Product> filteredProducts = AppData.products.obs;
  RxList<Product> cartProducts = <Product>[].obs;
  RxList<ProductCategory> categories = AppData.categories.obs;
  RxInt totalPrice = 0.obs;

  void filterItemsByCategory(int index) {
    for (ProductCategory element in categories) {
      element.isSelected = false;
    }
    categories[index].isSelected = true;

    if (categories[index].type == ProductType.all) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(allProducts.where((item) {
        return item.type == categories[index].type;
      }).toList());
    }
    update();
  }

  void isFavorite(int index) {
    filteredProducts[index].isFavorite = !filteredProducts[index].isFavorite;
    update();
  }

  void addToCart(Product product) {
    var existingProduct = cartProducts.firstWhere(
      (item) => item.id == product.id,
      orElse: () => product,
    );

    if (cartProducts.contains(existingProduct)) {
      existingProduct.quantity++;
    } else {
      product.quantity = 1;
      cartProducts.add(product);
    }
    calculateTotalPrice();
    update();
  }

  void increaseItemQuantity(Product product) {
    product.quantity++;
    calculateTotalPrice();
    update();
  }

  void decreaseItemQuantity(Product product) {
    if (product.quantity > 0) {
      product.quantity--;
      if (product.quantity == 0) {
        cartProducts.remove(product);
      }
      calculateTotalPrice();
      update();
    }
  }

  bool isPriceOff(Product product) => product.off != null;

  bool get isEmptyCart => cartProducts.isEmpty;

  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      if (isPriceOff(element)) {
        totalPrice.value += element.quantity * element.off!;
      } else {
        totalPrice.value += element.quantity * element.price;
      }
    }
  }

  getFavoriteItems() {
    filteredProducts.assignAll(
      allProducts.where((item) => item.isFavorite),
    );
  }

  getCartItems() {
    cartProducts.assignAll(
      allProducts.where((item) => item.quantity > 0),
    );
  }

  getAllItems() {
    filteredProducts.assignAll(allProducts);
  }
}
