import 'package:flutter/material.dart';
import '../widgets/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
      ),
    );
  }
}
