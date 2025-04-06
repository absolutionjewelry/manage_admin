import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/token.dart';
import '../requests/endpoints.dart';
import '../providers/token.dart';

final authProvider = StateProvider<Token?>((ref) => null);

Future<void> signOut(WidgetRef ref) async {
  final token = ref.read(authProvider);
  if (token == null) return;

  await http.delete(
    Uri.parse(logoutPath),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token.value}',
    },
  );
  ref.read(authProvider.notifier).state = null;
  ref.read(tokenProvider.notifier).clearToken();
}

Future<Token?> resetPassword({
  required WidgetRef ref,
  required String username,
  required String password,
  required String code,
}) async {
  final response = await http.post(
    Uri.parse(resetPasswordPath),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'newPassword': password,
      'code': code,
    }),
  );

  final body = jsonDecode(response.body);
  if (body['error'] == null) {
    final tokenValue = body['data']['token'];
    final expiresAt = body['data']['expiresAt'];
    final userId = body['data']['userId'];
    final token = Token(
      value: tokenValue,
      expiresAt: DateTime.parse(expiresAt),
      userId: userId,
    );

    ref.read(tokenProvider.notifier).setToken(token);
    ref.read(authProvider.notifier).state = token;
    return token;
  }

  return null;
}
