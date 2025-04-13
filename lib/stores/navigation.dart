import 'package:flutter/material.dart';
import '../ui/screen_navigation_item.dart';
import 'products/products.dart';
import 'stores.dart';
import 'store.dart';

enum ScreenNavigationActiveItem { stores, store, products }

List<ScreenNavigationItem> storeNavigation({
  required String storeId,
  required BuildContext context,
  bool collapsed = true,
  ScreenNavigationActiveItem? activeItem,
}) {
  return [
    ScreenNavigationItem(
      icon: Icons.domain_rounded,
      title: 'Stores',
      tooltip: 'Stores',
      isActive: activeItem == ScreenNavigationActiveItem.stores,
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
      isActive: activeItem == ScreenNavigationActiveItem.store,
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
      isActive: activeItem == ScreenNavigationActiveItem.products,
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
