import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/products.dart';
import '../../ui/screen_container.dart';
import '../../ui/screen_navigation_bar.dart';

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
                                    onPressed: () {},
                                    icon: const Icon(Icons.add),
                                    label: const Text('Create Product'),
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: data.length,
                                itemBuilder:
                                    (context, index) =>
                                        Text(data[index].productName),
                              ),
                  error: (error, stack) => Text(error.toString()),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                ),
      ),
      floatingActionButton:
          isLoading
              ? null
              : FloatingActionButton.extended(
                onPressed: () {},
                label: const Text('Create Product'),
                icon: const Icon(Icons.add),
              ),
    );
  }
}
