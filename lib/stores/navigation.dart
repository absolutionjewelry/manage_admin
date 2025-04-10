import 'package:flutter/material.dart';
import '../ui/screen_navigation_item.dart';
import 'products/products.dart';
import 'stores.dart';
import 'store.dart';

List<ScreenNavigationItem> storeNavigation({
  required String storeId,
  required BuildContext context,
  bool collapsed = true,
}) {
  return [
    ScreenNavigationItem(
      icon: Icons.domain_rounded,
      title: 'Stores',
      tooltip: 'Stores',
      collapsed: collapsed,
      onPressed:
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StoresView()),
          ),
    ),
    ScreenNavigationItem(
      icon: Icons.store_rounded,
      title: 'Store',
      tooltip: 'Store',
      collapsed: collapsed,
      onPressed:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StoreView(storeId: storeId),
            ),
          ),
    ),
    ScreenNavigationItem(
      icon: Icons.shopping_bag_rounded,
      title: 'Products',
      tooltip: 'Products',
      collapsed: collapsed,
      onPressed:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductsView(storeId: storeId),
            ),
          ),
    ),
  ];
}
