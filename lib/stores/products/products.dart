import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_admin/ui/navigation_card.dart';
import '../../models/product.dart';
import '../../providers/products.dart';
import '../../ui/screen_container.dart';
import '../../ui/screen_navigation_bar.dart';
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
      getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(title: 'Products'),
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
                                height:
                                    MediaQuery.of(context).size.height - 104,
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
                                height:
                                    MediaQuery.of(context).size.height - 104,
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
                                              onTap:
                                                  () => Navigator.of(
                                                    context,
                                                  ).push(
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              ProductView(
                                                                product:
                                                                    product,
                                                              ),
                                                    ),
                                                  ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                  error: (error, stack) => Text(error.toString()),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createProduct(context),
        label: const Text('Create Product'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
