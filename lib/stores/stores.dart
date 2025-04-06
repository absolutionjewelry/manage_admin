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

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(store.storeName ?? '', textAlign: TextAlign.center),
          Text(store.storeDescription ?? '', textAlign: TextAlign.center),
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
