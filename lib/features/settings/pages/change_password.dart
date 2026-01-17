import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';

import '../../../core/utils/feedback_utils.dart';
import '../../user/providers/user_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      final currentPassword = _currentPasswordController.text;
      final newPassword = _newPasswordController.text;

      final user = ref.read(currentUserProvider).value;
      if (user == null) return;

      try {
        await ref
            .read(authProvider.notifier)
            .patchUser(user: user, password: newPassword);

        if (mounted) {
          FeedbackUtils.showSuccess(context, "Password changed successfully");
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          FeedbackUtils.showError(context, e.toString());
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cambia Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Attuale",
                ),
                validator: (value) => (value?.isEmpty ?? true)
                    ? "Questo campo è obbligatorio"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Nuova Password"),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Questo campo è obbligatorio";
                  }
                  if (value!.length < 6) {
                    return "La password deve essere di almeno 6 caratteri";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Conferma Nuova Password",
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return "Le password non coincidono";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("SALVA MODIFICHE"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
