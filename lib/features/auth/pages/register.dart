import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'package:greenlinkapp/router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String errorMessage = ''; // ← QUI

  @override
  void dispose() {
    nicknameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); // pulisco la memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenLink')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(),
            const SizedBox(height: 24),
            AuthTextField(
              hint: 'Nickname',
              controller: nicknameController,
              obscure: false,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              hint: 'Email',
              controller: emailController,
              obscure: false,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              hint: 'Password',
              controller: passwordController,
              obscure: true,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              hint: 'Confirm Password',
              controller: confirmPasswordController,
              obscure: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage.isNotEmpty)...[
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],
            AuthButton(
              label: 'Registrati',
              textColor: Colors.white,
              onPressed: () {
                final email = emailController.text.trim();
                final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                if (!emailRegex.hasMatch(email)) {
                  setState(() {
                    errorMessage = 'Email non valida';
                  });
                  return;
                }
                if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                  setState(() {
                    errorMessage = 'Le password non coincidono';
                  });
                  return;
                }
                print(nicknameController.text);
                print(emailController.text.trim());
                print(passwordController.text.trim());
                print(confirmPasswordController.text.trim());
                nicknameController.clear();
                emailController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                router.go('/login');
              },
              child: Text(
                'Torna al login cliccando qui.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
