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
