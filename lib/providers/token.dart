import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/auth.dart';
import '../models/token.dart';

final tokenProvider = AsyncNotifierProvider<TokenNotifier, Token?>(() {
  return TokenNotifier();
});

class TokenNotifier extends AsyncNotifier<Token?> {
  Token? token;

  TokenNotifier({this.token});

  @override
  Future<Token?> build() async {
    return token;
  }

  Future<void> setToken(Token token) async {
    if (token.value == null) {
      await AuthStorage.clearToken();
      state = AsyncData(null);
      return;
    }
    if (token.expiresAt != null && token.expiresAt!.isBefore(DateTime.now())) {
      await AuthStorage.clearToken();
      state = AsyncData(null);
      return;
    }
    this.token = token;
    await AuthStorage.setToken(token);
    state = AsyncData(token);
  }

  Future<void> clearToken() async {
    token = null;
    await AuthStorage.clearToken();
    state = AsyncData(null);
  }
}
