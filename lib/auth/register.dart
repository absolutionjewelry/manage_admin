import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import '../requests/endpoints.dart';
import 'package:flutter/services.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isShowingPassword = false;

  final backupCodes = [];

  Future<void> register(context) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final navigator = Navigator.of(context);

    final response = await http.post(
      Uri.parse(registerPath),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      final List<String> newBackupCodes = [];
      for (var code in jsonResponse["data"]["backupCodes"]) {
        newBackupCodes.add(code.toString());
      }
      setState(() {
        backupCodes.addAll(newBackupCodes);
      });

      await showDialog(
        context: context,
        builder: (context) => BackupCodesDialog(backupCodes: newBackupCodes),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => LoginView()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration failed: ${jsonResponse["message"]}'),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AutofillGroup(
                          child: TextField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: Icon(Icons.text_fields_rounded),
                            ),
                            onSubmitted: (value) => register(context),
                            autofillHints: const [AutofillHints.givenName],
                          ),
                        ),
                        AutofillGroup(
                          child: TextField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              prefixIcon: Icon(Icons.text_fields_rounded),
                            ),
                            onSubmitted: (value) => register(context),
                            autofillHints: const [AutofillHints.familyName],
                          ),
                        ),
                        AutofillGroup(
                          child: TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_rounded),
                            ),
                            onSubmitted: (value) => register(context),
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
                            onSubmitted: (value) => register(context),
                            autofillHints: const [AutofillHints.password],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () => register(context),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed:
                            () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ),
                            ),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}

class BackupCodesDialog extends StatefulWidget {
  const BackupCodesDialog({super.key, required this.backupCodes});

  final List<String> backupCodes;

  @override
  State<BackupCodesDialog> createState() => _BackupCodesDialogState();
}

class _BackupCodesDialogState extends State<BackupCodesDialog> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Backup Codes'),
      content: Column(
        children: [
          SelectableRegion(
            selectionControls: MaterialTextSelectionControls(),
            child: StaggeredGrid.count(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
              children:
                  widget.backupCodes
                      .map(
                        (code) => Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            code,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: widget.backupCodes.join('\n')),
                  );
                  setState(() {
                    isCopied = true;
                  });
                },
                icon: isCopied ? Icon(Icons.check) : Icon(Icons.copy),
                label: Text('Copy Backup Codes'),
              ),
            ],
          ),
          Text(
            'Please save these codes in a secure location. If you lose your device, you can use these codes to recover your account.',
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
