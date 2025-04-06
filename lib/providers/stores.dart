import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/store.dart';
import '../requests/endpoints.dart';
import 'auth.dart';

final storesProvider = AsyncNotifierProvider<StoresNotifier, List<Store>>(
  () => StoresNotifier(),
);

class StoresNotifier extends AsyncNotifier<List<Store>> {
  StoresNotifier() : super();

  @override
  List<Store> build() {
    return [];
  }

  Future<void> getStores() async {
    final token = ref.read(authProvider);
    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error(
        "Invalid token. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final response = await http.get(
      Uri.parse(storesPath),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.value}",
      },
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      final stores = body["data"] as List<dynamic>;
      state = AsyncValue.data(stores.map((e) => Store.fromJson(e)).toList());
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}

final deleteStoreProvider = AsyncNotifierProvider<DeleteStoreNotifier, void>(
  () => DeleteStoreNotifier(),
);

class DeleteStoreNotifier extends AsyncNotifier<void> {
  DeleteStoreNotifier() : super();

  @override
  void build() {
    return;
  }

  Future<void> deleteStore(String id) async {
    final token = ref.read(authProvider);
    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error(
        "Invalid token. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final response = await http.delete(
      Uri.parse("$storesPath/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.value}",
      },
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      ref.read(storesProvider.notifier).getStores();
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}

final createStoreProvider = AsyncNotifierProvider<CreateStoreNotifier, Store?>(
  () => CreateStoreNotifier(),
);

class CreateStoreNotifier extends AsyncNotifier<Store?> {
  CreateStoreNotifier() : super();

  @override
  Store? build() {
    return null;
  }

  Future<void> createStore({
    required String name,
    required String description,
  }) async {
    final token = ref.read(authProvider);
    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error(
        "Invalid token. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final response = await http.post(
      Uri.parse(storesPath),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.value}",
      },
      body: jsonEncode({"storeName": name, "storeDescription": description}),
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      state = AsyncValue.data(Store.fromJson(body["data"]));
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}

final updateStoreProvider = AsyncNotifierProvider<UpdateStoreNotifier, Store?>(
  () => UpdateStoreNotifier(),
);

class UpdateStoreNotifier extends AsyncNotifier<Store?> {
  UpdateStoreNotifier() : super();

  @override
  Store? build() {
    return null;
  }

  Future<void> updateStore({
    required String id,
    required String name,
    required String description,
  }) async {
    final token = ref.read(authProvider);
    if (token == null) {
      state = AsyncValue.error("You're not logged in", StackTrace.current);
      return;
    }

    if (!token.isValid) {
      state = AsyncValue.error(
        "Invalid token. Please log in again.",
        StackTrace.current,
      );
      return;
    }

    final response = await http.put(
      Uri.parse("$storesPath/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token.value}",
      },
      body: jsonEncode({"storeName": name, "storeDescription": description}),
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      state = AsyncValue.data(Store.fromJson(body["data"]));
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}
