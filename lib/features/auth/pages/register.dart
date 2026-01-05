import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/auth/widgets/joinbutton.dart';
import 'package:greenlinkapp/features/legal/pages/legal_document_page.dart';

import '../../../core/utils/feedback_utils.dart';
import '../widgets/textfield.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends ConsumerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // pulisco la memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          if (!mounted) return;
          FeedbackUtils.showError(context, error);
        },
      );
    });
    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                          hint: 'Username',
                          controller: _usernameController,
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
                          hint: 'Conferma Password',
                          controller: _confirmPasswordController,
                          obscure: true,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            TextButton(
                              onPressed: () => _openLegal(
                                "Privacy Policy",
                                "https://greenlink.tommasodeste.it/privacy-policy.html",
                              ),
                              child: const Text("Privacy Policy"),
                            ),
                            TextButton(
                              onPressed: () => _openLegal(
                                "Termini e Condizioni",
                                "https://greenlink.tommasodeste.it/terms-conditions.html",
                              ),
                              child: const Text("Termini e Condizioni"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        JoinButton(
                          onPressed: () {
                            ref
                                .read(authProvider.notifier)
                                .register(
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                );
                          },
                          isLoading: authState.isLoading,
                          label: "Registrati",
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.replace('/login'),
                          child: const Text(
                            "Gia registrato? Accedi cliccando qui.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 24),
                child: TextButton.icon(
                  onPressed: () => context.push('/partner-token'),
                  icon: const Icon(Icons.vpn_key, color: Colors.white),
                  label: const Text(
                    "Partner",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLegal(String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LegalDocumentPage(title: title, url: url),
      ),
    );
  }
}
