import 'package:flutter/material.dart';
import 'package:mobile_app/components/my_text_fields.dart';
import 'package:mobile_app/pages/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.message,
                size: 80,
              ),
              const SizedBox(height: 25),
              const Text(
                "Welcome back you've been missed",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // email textField
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              // password textField
              MyTextField(
                controller: passWordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              // sign in button
              MyButton(onTap: () {}, text: 'Sign In'),
              const SizedBox(
                height: 25,
              ),

              // not a member
              const Row(
                children: [
                  Text('Not a member?'),
                  SizedBox(width: 4),
                  Text(
                    'Register now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
