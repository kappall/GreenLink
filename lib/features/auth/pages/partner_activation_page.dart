import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/auth/widgets/joinbutton.dart';

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
              Text( 
                "Attiva il tuo account partner inserendo il token di invito e creando una password.",
                style: const TextStyle(color: Colors.grey),
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
                      JoinButton(
                        onPressed: () {
                          _submit();
                        },
                        isLoading: authState.isLoading,
                        label: "Registrati",
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

/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';

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

  bool _obscurePass = true;
  bool _obscureConfirm = true;

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
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Attiva Account Partner")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Benvenuto Partner",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Inserisci il token ricevuto e crea la tua password.",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: "Token di Invito (JWT)",
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Token richiesto";
                    if (value.length < 20) return "Token non valido";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passController,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: "Nuova Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return "Minimo 6 caratteri";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: "Conferma Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passController.text)
                      return "Le password non coincidono";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      state.error.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ElevatedButton(
                  onPressed: state.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Attiva Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
