import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/content_container.dart';
import '../../models/product.dart';
import '../../providers/products.dart';
import '../../helpers/formatters.dart';

class ProductForm extends ConsumerStatefulWidget {
  final Product product;
  final String storeId;

  const ProductForm({super.key, required this.product, required this.storeId});

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final quantityController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  save(context) async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name is required')));
      return;
    }

    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Description is required')));
      return;
    }

    if (priceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Price is required')));
      return;
    }

    if (costController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cost is required')));
      return;
    }

    if (quantityController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quantity is required')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (widget.product.id == null) {
      await ref
          .read(createProductProvider.notifier)
          .createProduct(
            storeId: widget.storeId,
            product: Product(
              id: widget.product.id,
              storeId: widget.storeId,
              productName: nameController.text,
              productDescription: descriptionController.text,
              productBasePrice: double.parse(priceController.text),
              productBaseCost: double.parse(costController.text),
              productBaseQuantity: double.parse(quantityController.text),
            ),
          );
    } else {
      await ref
          .read(updateProductProvider.notifier)
          .updateProduct(
            storeId: widget.storeId,
            product: widget.product.copyWith(
              productName: nameController.text,
              productDescription: descriptionController.text,
              productBasePrice: double.parse(priceController.text),
              productBaseCost: double.parse(costController.text),
              productBaseQuantity: double.parse(quantityController.text),
            ),
          );
    }

    setState(() {
      isLoading = false;
    });

    final result =
        widget.product.id == null
            ? ref.read(createProductProvider)
            : ref.read(updateProductProvider);
    result.when(
      data: (data) {
        Navigator.of(context).pop(true);
      },
      error: (error, stack) {
        setState(() {
          errorMessage = error.toString();
        });
        // Navigator.of(context).pop(false);
      },
      loading: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.product.id != null) {
      nameController.text = widget.product.productName ?? '';
      descriptionController.text = widget.product.productDescription ?? '';
      priceController.text = widget.product.productBasePrice?.toString() ?? '';
      costController.text = widget.product.productBaseCost?.toString() ?? '';
      quantityController.text =
          widget.product.productBaseQuantity?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ContentContainer(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.title),
                ),
                onSubmitted: (value) => save(context),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 7,
                onSubmitted: (value) => save(context),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.money),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[\d.]*$')),
                  SinglePeriodInputFormatter(),
                ],
                onSubmitted: (value) => save(context),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              TextField(
                controller: costController,
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  prefixIcon: Icon(Icons.money),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[\d.]*$')),
                  SinglePeriodInputFormatter(),
                ],
                onSubmitted: (value) => save(context),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.inventory),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[\d.]*$')),
                  SinglePeriodInputFormatter(),
                ],
                onSubmitted: (value) => save(context),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                    ),
                    FilledButton.icon(
                      onPressed: () => save(context),
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ],
                ),
              ),
              if (errorMessage.isNotEmpty)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
  }
}
