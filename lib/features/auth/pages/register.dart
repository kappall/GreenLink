import 'package:flutter/material.dart';
import '../widgets/button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthButton(
                label: 'Register',
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to registration page
                },
                child:Text(
                'Torna al login cliccando qui.',
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
