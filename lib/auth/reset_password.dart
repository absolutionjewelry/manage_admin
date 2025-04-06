import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_admin/auth/login.dart';
import '../app.dart';
import '../providers/auth.dart' as auth;

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPasswordView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();
  bool isLoading = false;
  bool isShowPassword = false;
  String error = '';

  Future<void> resetPassword(context) async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        error = 'Passwords do not match';
      });
      return;
    }
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        codeController.text.isEmpty) {
      setState(() {
        error = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await auth.resetPassword(
      ref: ref,
      username: usernameController.text,
      password: passwordController.text,
      code: codeController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const App()),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Invalid backup code')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AutofillGroup(
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.person),
                              ),
                              autofillHints: const [AutofillHints.username],
                              onSubmitted: (value) => resetPassword(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.password),
                                suffixIcon: IconButton(
                                  onPressed:
                                      () => setState(
                                        () => isShowPassword = !isShowPassword,
                                      ),
                                  icon:
                                      isShowPassword
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                ),
                              ),
                              autofillHints: const [AutofillHints.password],
                              obscureText: !isShowPassword,
                              onSubmitted: (value) => resetPassword(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: const Icon(Icons.password),
                                suffixIcon: IconButton(
                                  onPressed:
                                      () => setState(
                                        () => isShowPassword = !isShowPassword,
                                      ),
                                  icon:
                                      isShowPassword
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                ),
                              ),
                              autofillHints: const [AutofillHints.password],
                              obscureText: !isShowPassword,
                              onSubmitted: (value) => resetPassword(context),
                            ),
                          ),
                          AutofillGroup(
                            child: TextField(
                              controller: codeController,
                              decoration: InputDecoration(
                                labelText: 'Backup Code',
                                prefixIcon: const Icon(
                                  Icons.lock_reset_rounded,
                                ),
                              ),
                              autofillHints: const [AutofillHints.oneTimeCode],
                              onSubmitted: (value) => resetPassword(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton.icon(
                            onPressed: () => resetPassword(context),
                            icon: const Icon(Icons.send),
                            label: const Text('Reset Password'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Remember your password?'),
                          TextButton(
                            onPressed:
                                () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                ),
                            child: Text('Login'),
                          ),
                        ],
                      ),
                    ),
                    if (error.isNotEmpty)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
