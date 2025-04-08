import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_admin/ui/screen_container.dart';
import 'package:manage_admin/ui/screen_navigation_bar.dart';

class ProductsView extends ConsumerStatefulWidget {
  final String storeId;

  const ProductsView({super.key, required this.storeId});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(title: 'Products'),
        child: Text('Products'),
      ),
    );
  }
}
