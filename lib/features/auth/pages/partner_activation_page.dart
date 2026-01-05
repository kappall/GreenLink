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

class PartnerActivationPage extends ConsumerStatefulWidget {
  const PartnerActivationPage({super.key});

  @override
  ConsumerState<PartnerActivationPage> createState() =>
      _PartnerActivationPageState();
}

class _PartnerActivationPageState extends ConsumerState<PartnerActivationPage> {
  final _formKey = GlobalKey<FormState>();

  final _tokenController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .registerPartner(
          token: _tokenController.text.trim(),
          password: _passController.text.trim(),
        );
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
              const SizedBox(height: 32),
              const Text(
                "Attiva il tuo account partner inserendo il token di invito e creando una password.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              UiCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        hint: 'Token di Invito (JWT)',
                        controller: _tokenController,
                        obscure: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Token richiesto";
                          }
                          if (value.length < 20) return "Token non valido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hint: 'Password',
                        controller: _passController,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Minimo 6 caratteri";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        hint: 'Conferma Password',
                        controller: _confirmController,
                        obscure: true,
                        validator: (value) {
                          if (value != _passController.text) {
                            return "Le password non coincidono";
                          }
                          return null;
                        },
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
                                text: "Attivando l'account, accetti i nostri ",
                              ),
                              TextSpan(
                                text: "Termini e Condizioni",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
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
                                  color: Theme.of(context).colorScheme.primary,
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
                          _submit();
                        },
                        isLoading: authState.isLoading,
                        label: "Attiva Account",
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.replace('/login'),
                        child: const Text("Torna alla schermata di login"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
