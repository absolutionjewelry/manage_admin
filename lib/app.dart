import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme_data.dart';
import 'auth/login.dart';
import 'providers/auth.dart';
import 'stores/stores.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: AppThemeData.theme,
      home:
          ref.watch(authProvider) == null
              ? const LoginView()
              : const StoresView(),
    );
  }
}
