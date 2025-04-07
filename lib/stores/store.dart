import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stores.dart';

class StoreView extends ConsumerStatefulWidget {
  final String storeId;

  const StoreView({super.key, required this.storeId});

  @override
  ConsumerState<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends ConsumerState<StoreView> {
  @override
  void initState() {
    super.initState();
    getStore();
  }

  Future<void> getStore() async {
    await ref.read(getStoreProvider.notifier).getStore(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(getStoreProvider);
    return store.when(
      data:
          (store) => Scaffold(
            appBar: AppBar(
              title: Text(store?.storeName ?? 'Unknown Store'),
              centerTitle: true,
            ),
            body: Center(child: Text(store?.storeName ?? '')),
          ),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error'))),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
