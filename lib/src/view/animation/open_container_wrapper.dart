import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bitirme/src/model/product.dart';
import 'package:bitirme/src/view/screen/product_detail_screen.dart';

 // ürün listesi ve favori ekranındaki ürün kartlarının açılıp kapanması için efekt.
class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    super.key,
    required this.child,
    required this.product,
  });

  final Widget child;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      closedColor: const Color(0xFFE5E6E8),
      transitionType: ContainerTransitionType.fade, // geçiş efektini ayarladığımız yer.
      transitionDuration: const Duration(milliseconds: 850), // efektin süresi
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) => ProductDetailScreen(product),
    );
  }
}
