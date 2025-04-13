import 'navigation.dart';

import '../ui/navigation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stores.dart';
import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/screen_navigation_drawer.dart';
import 'products/products.dart';

class StoreView extends ConsumerStatefulWidget {
  final String storeId;

  const StoreView({super.key, required this.storeId});

  @override
  ConsumerState<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends ConsumerState<StoreView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getStore();
  }

  Future<void> getStore() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(getStoreProvider.notifier).getStore(widget.storeId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(getStoreProvider);

    return store.when(
      data: (store) {
        return Scaffold(
          body: ScreenContainer(
            navigationBar: ScreenNavigationBar(
              title: 'Store',
              navigationItems: [
                ...storeNavigation(
                  storeId: store?.id ?? '',
                  context: context,
                  activeItem: ScreenNavigationActiveItem.store,
                ),
              ],
            ),
            navigationDrawer: ScreenNavigationDrawer(
              children: [
                ...storeNavigation(
                  storeId: store?.id ?? '',
                  context: context,
                  collapsed: false,
                  activeItem: ScreenNavigationActiveItem.store,
                ),
              ],
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: MediaQuery.of(context).size.height - 104,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                    : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 104,
                      child: GridView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 300,
                        ),
                        children: [
                          NavigationCard(
                            title: 'Products',
                            subtitle: 'Manage your products',
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductsView(
                                          storeId: widget.storeId,
                                        ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
      error: (error, stack) => Scaffold(body: Center(child: Text('Error'))),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
