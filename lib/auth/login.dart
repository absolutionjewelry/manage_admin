import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../requests/endpoints.dart';
import '../providers/token.dart';
import '../providers/auth.dart';
import '../app.dart';
import '../models/token.dart';
import '../auth/register.dart';
import '../auth/reset_password.dart';
import '../ui/content_container.dart';
import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isShowingPassword = false;

  Future<void> login(context) async {
    setState(() {
      isLoading = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text('Please enter a username and password')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse(loginPath),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      messenger.showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final body = jsonDecode(response.body);
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const App()),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(title: 'Login'),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    ContentContainer(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          AutofillGroup(
                            child: TextField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_rounded),
                              ),
                              onSubmitted: (value) => login(context),
                              autofillHints: const [AutofillHints.username],
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: passwordController,
                              obscureText: !isShowingPassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.password_rounded),
                                suffixIcon: IconButton(
                                  onPressed:
                                      () => setState(() {
                                        isShowingPassword = !isShowingPassword;
                                      }),
                                  icon:
                                      isShowingPassword
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                ),
                              ),
                              onSubmitted: (value) => login(context),
                              autofillHints: const [AutofillHints.password],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed:
                                      () =>
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const ResetPasswordView(),
                                            ),
                                          ),
                                  child: const Text('Forgot Password?'),
                                ),
                                FilledButton(
                                  onPressed: () => login(context),
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ContentContainer(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withAlpha(200),
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed:
                                () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterView(),
                                  ),
                                ),
                            child: Text('Register'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
