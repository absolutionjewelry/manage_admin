import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store.dart';
import '../providers/stores.dart';
import '../providers/auth.dart';
import '../app.dart';

class StoresView extends ConsumerStatefulWidget {
  const StoresView({super.key});

  @override
  ConsumerState<StoresView> createState() => _StoresViewState();
}

class _StoresViewState extends ConsumerState<StoresView> {
  @override
  void initState() {
    super.initState();
    getStores();
  }

  Future<void> getStores() async {
    await ref.read(storesProvider.notifier).getStores();
  }

  @override
  Widget build(BuildContext context) {
    final stores = ref.watch(storesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await signOut(ref);
              navigator.pushReplacement(
                MaterialPageRoute(builder: (context) => const App()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: stores.when(
        data:
            (data) =>
                data.isNotEmpty
                    ? GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width ~/ 300,
                      ),
                      itemCount: data.length,
                      itemBuilder:
                          (context, index) => StoreCard(store: data[index]),
                    )
                    : Center(
                      child: FilledButton.icon(
                        onPressed:
                            () => showDialog(
                              context: context,
                              builder: (context) => const CreateStoreDialog(),
                            ),
                        icon: Icon(Icons.add),
                        label: Text('Create a store'),
                      ),
                    ),
        error:
            (error, stack) => Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(
                  error.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) => const CreateStoreDialog(),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class StoreCard extends ConsumerStatefulWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  ConsumerState<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends ConsumerState<StoreCard> {
  bool isLoading = false;

  delete(context, ref) async {
    final response = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Store'),
            content: Text(
              'Are you sure you want to delete ${widget.store.storeName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (response == true) {
      setState(() {
        isLoading = true;
      });

      await ref.read(storesProvider.notifier).deleteStore(widget.store.id);
      final response = ref.read(storesProvider);

      response.when(
        data: (data) async {
          await ref.read(storesProvider.notifier).getStores();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Store deleted successfully')),
          );

          Navigator.of(context).pop();
        },
        error: (error, stack) {
          setState(() {
            isLoading = false;
          });
        },
        loading: () {
          setState(() {
            isLoading = true;
          });
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store deleted successfully')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.store.storeName ?? '',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.store.storeDescription ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton(
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(children: [Icon(Icons.edit), Text('Edit')]),
                    ),
                    PopupMenuItem(
                      onTap: () => delete(context, ref),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          Text(
                            'Delete',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateStoreDialog extends ConsumerStatefulWidget {
  const CreateStoreDialog({super.key});

  @override
  ConsumerState<CreateStoreDialog> createState() => _CreateStoreDialogState();
}

class _CreateStoreDialogState extends ConsumerState<CreateStoreDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;
  String error = '';

  save(context) async {
    if (nameController.text.isEmpty) {
      setState(() {
        error = 'Name is required';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    await ref
        .read(createStoreProvider.notifier)
        .createStore(
          name: nameController.text,
          description: descriptionController.text,
        );

    final store = ref.read(createStoreProvider);

    store.when(
      data: (data) async {
        await ref.read(storesProvider.notifier).getStores();

        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Store created successfully')));
      },
      error: (error, stack) {
        setState(() {
          error = error.toString();
          isLoading = false;
        });
      },
      loading: () {
        setState(() {
          isLoading = true;
        });
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Text(
                    'Create a store',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          onSubmitted: (value) => save(context),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        FilledButton.icon(
                          onPressed: () => save(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Create Store'),
                        ),
                      ],
                    ),
                  ),
                  if (error.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        error,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
