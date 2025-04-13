import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stores/navigation.dart';
import '../../ui/navigation_card.dart';
import '../../models/product.dart';
import '../../providers/products.dart';
import '../../ui/screen_container.dart';
import '../../ui/screen_navigation_bar.dart';
import '../../ui/screen_navigation_drawer.dart';
import 'form.dart';
import 'product.dart';

class ProductsView extends ConsumerStatefulWidget {
  final String storeId;

  const ProductsView({super.key, required this.storeId});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  bool isLoading = false;
  bool isProductLoading = false;
  Product? currentProduct;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(productsProvider.notifier).getProducts(widget.storeId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> createProduct(context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            child: ProductForm(storeId: widget.storeId, product: Product()),
          ),
    );
    if (result == true) {
      await ref.read(productsProvider.notifier).getProducts(widget.storeId);
    }
  }

  Future<void> editProduct(Product product) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            child: ProductForm(storeId: widget.storeId, product: product),
          ),
    );
    if (result == true) {
      await ref.read(productsProvider.notifier).getProducts(widget.storeId);
    }
  }

  Future<void> deleteProduct(Product product) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
    );

    if (result == true) {
      setState(() {
        isProductLoading = true;
        currentProduct = product;
      });
      await ref
          .read(deleteProductProvider.notifier)
          .deleteProduct(storeId: widget.storeId, product: product);

      final result = ref.read(deleteProductProvider);

      result.when(
        data: (data) async {
          await ref.read(productsProvider.notifier).getProducts(widget.storeId);
          setState(() {
            isProductLoading = false;
            currentProduct = null;
          });
        },
        error: (error, stack) {
          setState(() {
            isProductLoading = false;
            currentProduct = null;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    return ScreenContainer(
      navigationBar: ScreenNavigationBar(
        title: 'Products',
        navigationItems: [
          ...storeNavigation(
            storeId: widget.storeId,
            context: context,
            activeItem: ScreenNavigationActiveItem.products,
          ),
        ],
        actions: [
          IconButton.filled(
            onPressed: () => createProduct(context),
            icon: const Icon(Icons.add),
            tooltip: 'Create Product',
          ),
        ],
      ),
      navigationDrawer: ScreenNavigationDrawer(
        children: [
          ...storeNavigation(
            storeId: widget.storeId,
            context: context,
            collapsed: false,
            activeItem: ScreenNavigationActiveItem.products,
          ),
        ],
      ),
      child:
          isLoading
              ? SizedBox(
                height: MediaQuery.of(context).size.height - 104,
                child: const Center(child: CircularProgressIndicator()),
              )
              : products.when(
                data:
                    (data) =>
                        data.isEmpty
                            ? Container(
                              padding: const EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.height - 104,
                              child: Center(
                                child: FilledButton.icon(
                                  onPressed: () => createProduct(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Create Product'),
                                ),
                              ),
                            )
                            : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 104,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width ~/
                                          300,
                                    ),
                                children:
                                    data
                                        .map(
                                          (product) => NavigationCard(
                                            title: product.productName ?? '',
                                            subtitle:
                                                product.productDescription ??
                                                '',
                                            isLoading:
                                                isProductLoading &&
                                                currentProduct?.id ==
                                                    product.id,
                                            onTap:
                                                () => Navigator.of(
                                                  context,
                                                ).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ProductView(
                                                              product: product,
                                                              storeId:
                                                                  widget
                                                                      .storeId,
                                                            ),
                                                  ),
                                                ),
                                            actions: [
                                              NavigationCardAction(
                                                icon: Icons.edit,
                                                label: 'Edit',
                                                onTap:
                                                    () => editProduct(product),
                                              ),
                                              NavigationCardAction(
                                                icon: Icons.delete,
                                                label: 'Delete',
                                                color: Colors.red,
                                                onTap:
                                                    () =>
                                                        deleteProduct(product),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                error: (error, stack) => Text(error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
