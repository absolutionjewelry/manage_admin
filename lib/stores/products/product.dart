import 'package:flutter/material.dart';
import '../../stores/navigation.dart';
import '../../ui/screen_navigation_drawer.dart';
import '../../models/product.dart';
import '../../ui/screen_container.dart';
import '../../ui/screen_navigation_bar.dart';

class ProductView extends StatelessWidget {
  final Product product;
  final String storeId;

  const ProductView({super.key, required this.product, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      navigationBar: ScreenNavigationBar(
        title: product.productName ?? '',
        navigationItems: [
          ...storeNavigation(storeId: storeId, context: context),
        ],
      ),
      navigationDrawer: ScreenNavigationDrawer(
        children: [
          ...storeNavigation(
            storeId: storeId,
            context: context,
            collapsed: false,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(product.productName ?? ''),
          Text(product.productDescription ?? ''),
        ],
      ),
    );
  }
}
