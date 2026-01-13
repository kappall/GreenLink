import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/auth/widgets/joinbutton.dart';
import 'package:greenlinkapp/features/legal/pages/privacy_policy_page.dart';
import 'package:greenlinkapp/features/legal/pages/terms_and_conditions_page.dart';

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
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Email',
                          controller: _emailController,
                          obscure: false,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          keyboardType: TextInputType.visiblePassword,
                          hint: 'Password',
                          controller: _passwordController,
                          obscure: true,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          keyboardType: TextInputType.visiblePassword,
                          hint: 'Conferma Password',
                          controller: _confirmPasswordController,
                          obscure: true,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Registrandoti, accetti i nostri ",
                                ),
                                TextSpan(
                                  text: "Termini e Condizioni",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsAndConditionsPage(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(text: " e la nostra "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PrivacyPolicyPage(),
                                        ),
                                      );
                                    },
                                ),
                                const TextSpan(text: "."),
                              ],
                            ),
                          ),
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
}
