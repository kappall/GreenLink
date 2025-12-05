import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'package:greenlinkapp/router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = ''; 

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(),
            const SizedBox(height: 24),
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
            if (errorMessage.isNotEmpty) ...[
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],
            AuthButton(
              label: 'Login',
              textColor: Colors.white,
              onPressed: () {
                final email = emailController.text.trim();
                final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                if (!emailRegex.hasMatch(email)) {
                  setState(() {
                    errorMessage = 'Inserisci un indirizzo email valido';
                  });
                  return;
                }
                print(emailController.text.trim());
                print(passwordController.text.trim());
                emailController.clear();
                passwordController.clear();
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                router.go('/register');
              },
              child: Text(
                'Non hai un account? Registrati cliccando qui.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
