import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../ui/screen_container.dart';
import '../../ui/screen_navigation_bar.dart';

class ProductView extends StatelessWidget {
  final Product product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      navigationBar: ScreenNavigationBar(title: product.productName ?? ''),
      child: Column(children: [Text(product.productName ?? '')]),
    );
  }
}
