import 'package:flutter/material.dart';
import 'package:mobile_app/components/my_text_fields.dart';
import 'package:mobile_app/pages/my_button.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPassWordController = TextEditingController();
//  sign up
  void signUp() {}

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
                "Let's create an account for you!",
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
              // consfirm password textField
              MyTextField(
                controller: confirmPassWordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              // sign in button
              MyButton(onTap: signUp, text: 'Sign Up'),
              const SizedBox(
                height: 25,
              ),

              // already a member
              Row(
                children: [
                  const Text('Already a member?'),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
