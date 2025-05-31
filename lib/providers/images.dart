import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import '../requests/endpoints.dart';
import '../providers/providers.dart';
import 'dart:convert';

final imagesProvider = AsyncNotifierProvider<ImagesProvider, List<Image>>(
  () => ImagesProvider(),
);

class ImagesProvider extends AsyncNotifier<List<Image>> {
  @override
  Future<List<Image>> build() async {
    return [];
  }

  Future<void> getImages(String storeId) async {
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
      Uri.parse('$storesPath/$storeId/images'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
    );

    final body = jsonDecode(response.body);

    if (body["error"] == null) {
      state = AsyncValue.data(
        (body["data"] as List).map((e) => Image.fromJson(e)).toList(),
      );
      return;
    }

    state = AsyncValue.error(body["message"], StackTrace.current);
  }
}

final createImageProvider =
    AsyncNotifierProvider<CreateImageProvider, Image?>(
      () => CreateImageProvider(),
    );

class CreateImageProvider extends AsyncNotifier<Image?> {
  @override
  Image? build() {
    return null;
  }

  Future<void> createImage({
    required String storeId,
    required Image image,
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

    final imageJson = jsonEncode(image.toJson());
  
}
