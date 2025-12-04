import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/logo.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'package:greenlinkapp/router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),

      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(),
              const SizedBox(height: 24),
              AuthTextField(
                hint: 'Nickname',
                controller: TextEditingController(),
                obscure: false,
              ),
              const SizedBox(height: 16),
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
              AuthTextField(
                hint: 'Confirm Password',
                controller: TextEditingController(),
                obscure: true,
              ),
              const SizedBox(height: 16),
              AuthButton(
                label: 'Registrati',
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  router.push('/login');
                },
                child:Text(
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
