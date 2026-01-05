import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/auth/widgets/joinbutton.dart';
import 'package:greenlinkapp/features/auth/widgets/textfield.dart';

import '../../../core/utils/feedback_utils.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              padding: const EdgeInsets.all(24),
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
                          controller: _emailController,
                          hint: "Email",
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          hint: "Password",
                          obscure: true,
                        ),

                        TextButton(
                          onPressed: () => context.replace('/register'),
                          child: const Text(
                            "Non hai un account? Registrati cliccando qui.",
                          ),
                        ),
                        const SizedBox(height: 16),

                        JoinButton(
                          onPressed: () {
                            ref
                                .read(authProvider.notifier)
                                .login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          },
                          isLoading: authState.isLoading,
                          label: "Accedi",
                        ),

                        const SizedBox(height: 16),

                        JoinButton(
                          onPressed: () =>
                              ref.read(authProvider.notifier).loginAnonymous(),
                          label: "Continua come Anonimo",
                          invert: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botton Activation Partner con label chiara
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
