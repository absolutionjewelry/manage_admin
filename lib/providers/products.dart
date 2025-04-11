import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import '../requests/endpoints.dart';
import '../providers/auth.dart';
import 'dart:convert';

final productsProvider = AsyncNotifierProvider<ProductsProvider, List<Product>>(
  () => ProductsProvider(),
);

class ProductsProvider extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return [];
  }

  Future<void> getProducts(String storeId) async {
    final token = ref.read(authProvider);

    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error("Invalid token", StackTrace.current);
      return;
    }

    final response = await http.get(
      Uri.parse('$storesPath/$storeId/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      state = AsyncValue.data(
        (body["data"] as List).map((e) => Product.fromJson(e)).toList(),
      );
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}

final createProductProvider =
    AsyncNotifierProvider<CreateProductProvider, Product?>(
      () => CreateProductProvider(),
    );

class CreateProductProvider extends AsyncNotifier<Product?> {
  @override
  Product? build() {
    return null;
  }

  Future<void> createProduct({
    required String storeId,
    required Product product,
  }) async {
    final token = ref.read(authProvider);

    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error("Invalid token", StackTrace.current);
      return;
    }

    final productJson = jsonEncode(product.toJson());

    try {
      final response = await http.post(
        Uri.parse('$storesPath/$storeId/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
        body: productJson,
      );

      final body = jsonDecode(response.body);

      if (body["error"] == null) {
        state = AsyncValue.data(Product.fromJson(body["data"]));
        return;
      }

      state = AsyncValue.error(body["message"], StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final updateProductProvider =
    AsyncNotifierProvider<UpdateProductNotifier, Product?>(
      () => UpdateProductNotifier(),
    );

class UpdateProductNotifier extends AsyncNotifier<Product?> {
  @override
  Product? build() {
    return null;
  }

  Future<void> updateProduct({
    required String storeId,
    required Product product,
  }) async {
    final token = ref.read(authProvider);

    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error("Invalid token", StackTrace.current);
      return;
    }

    final productJson = jsonEncode(product.toJson());

    try {
      final response = await http.put(
        Uri.parse('$storesPath/$storeId/products/${product.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
        body: productJson,
      );

      final body = jsonDecode(response.body);

      if (body["error"] == null) {
        state = AsyncValue.data(Product.fromJson(body["data"]));
        return;
      }

      state = AsyncValue.error(body["message"], StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final deleteProductProvider =
    AsyncNotifierProvider<DeleteProductNotifier, Product?>(
      () => DeleteProductNotifier(),
    );

class DeleteProductNotifier extends AsyncNotifier<Product?> {
  @override
  Product? build() {
    return null;
  }

  Future<void> deleteProduct({
    required String storeId,
    required Product product,
  }) async {
    final token = ref.read(authProvider);

    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error("Invalid token", StackTrace.current);
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$storesPath/$storeId/products/${product.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
      );

      final body = jsonDecode(response.body);

      if (body["error"] == null) {
        state = AsyncValue.data(product);
        return;
      }

      state = AsyncValue.error(body["message"], StackTrace.current);
    } catch (e, stacktrace) {
      print('Error deleting product: $e');
      print('Stacktrace: $stacktrace');
      state = AsyncValue.error(e.toString(), stacktrace);
    }
  }
}
