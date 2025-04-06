import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store.dart'; // For Store class
import '../providers/stores.dart'; // For createStoreProvider and storesProvider

class StoreForm extends ConsumerStatefulWidget {
  final Store store;

  const StoreForm({super.key, required this.store});

  @override
  ConsumerState<StoreForm> createState() => _StoreFormState();
}

class _StoreFormState extends ConsumerState<StoreForm> {
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

    if (widget.store.id != null) {
      await ref
          .read(updateStoreProvider.notifier)
          .updateStore(
            id: widget.store.id!,
            name: nameController.text,
            description: descriptionController.text,
          );

      final store = ref.read(updateStoreProvider);

      store.when(
        data: (data) async {
          await ref.read(storesProvider.notifier).getStores();

          setState(() {
            isLoading = false;
          });

          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Store updated successfully')));
        },
        error: (err, stack) {
          setState(() {
            error = err.toString();
            isLoading = false;
          });
        },
        loading: () {
          setState(() {
            isLoading = true;
          });
        },
      );
      return;
    }

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
      error: (err, stack) {
        setState(() {
          error = err.toString();
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
  void initState() {
    super.initState();
    if (widget.store.id != null) {
      nameController.text = widget.store.storeName ?? '';
      descriptionController.text = widget.store.storeDescription ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.store.id != null ? 'Edit store' : 'Create a store',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
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
                    decoration: const InputDecoration(labelText: 'Description'),
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
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton.icon(
                    onPressed: () => save(context),
                    icon: const Icon(Icons.add),
                    label: Text(
                      widget.store.id != null ? 'Update Store' : 'Create Store',
                    ),
                  ),
                ],
              ),
            ),
            if (error.isNotEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      error,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
  }
}
