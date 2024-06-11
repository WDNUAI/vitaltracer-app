import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/Sign_Up_screen.dart';
import 'package:vitaltracer_app/widgets/sign_up_widget.dart';
import 'components/custom_textfield.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: const SafeArea(
        child: SignScreenContent(),
      ),
    );
  }
}

class SignScreenContent extends StatelessWidget {
  const SignScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'lib/images/VTlogo.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 50),
              const Text(
                'Welcome to VitalTracer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              CustomTextField(
                hintText: 'Enter your password',
                obscureText: true,
                controller: passwordController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              signInSignUpButton(context, true, () {}),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
