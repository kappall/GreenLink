import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                controller: TextEditingController(),
                obscure: false,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hint: 'Password',
                controller: TextEditingController(),
                obscure: true,
              ),
              const SizedBox(height: 16),
              AuthButton(
                label: 'Login',
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to registration page
                },
                child:Text(
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
