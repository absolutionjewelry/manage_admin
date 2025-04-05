import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage/auth.dart';

import 'providers/token.dart';
import 'providers/auth.dart';
import 'app.dart';
import 'models/token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var token = await AuthStorage.getToken();
  var auth = token;
  if (token != null && token.isValid) {
    auth = Token(
      value: token.value,
      expiresAt: token.expiresAt,
      userId: token.userId,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        tokenProvider.overrideWith(() => TokenNotifier(token: auth)),
        authProvider.overrideWith((ref) => auth),
      ],
      child: App(),
    ),
  );
}
