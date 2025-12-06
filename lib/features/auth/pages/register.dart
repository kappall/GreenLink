import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import 'package:greenlinkapp/core/common/widgets/ui.dart';
import 'package:greenlinkapp/core/providers/auth_provider.dart';
import '../widgets/textfield.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends ConsumerState<RegisterPage> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // pulisco la memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const AppLogo(),
              const SizedBox(height: 16),
              const Text(
                "GreenLink",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              UiCard(
                child: Column(
                  children: [
                    AuthTextField(
                      hint: 'Nickname',
                      controller: _nicknameController,
                      obscure: false,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      hint: 'Email',
                      controller: _emailController,
                      obscure: false,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      hint: 'Password',
                      controller: _passwordController,
                      obscure: true,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      hint: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscure: true,
                    ),
                    const SizedBox(height: 16),
                    if (errorMessage.isNotEmpty) ...[
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                    ],
                    FilledButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final emailRegex = RegExp(
                                r'^[\w\.-]+@[\w\.-]+\.\w+$',
                              );

                              if (!emailRegex.hasMatch(email)) {
                                setState(() {
                                  errorMessage = 'Email non valida';
                                });
                                return;
                              }
                              if (_passwordController.text.trim() !=
                                  _confirmPasswordController.text.trim()) {
                                setState(() {
                                  errorMessage = 'Le password non coincidono';
                                });
                                return;
                              }
                              print(_nicknameController.text);
                              print(_emailController.text.trim());
                              print(_passwordController.text.trim());
                              print(_confirmPasswordController.text.trim());
                              _nicknameController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                              ref
                                  .read(authProvider.notifier)
                                  .register(
                                    _nicknameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                            },
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Registrati"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.replace('/login'),
                      child: const Text("Torna al login cliccando qui"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
