import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/sign_up_screen.dart';
import 'components/custom_textfield.dart';
import 'auth_service.dart';
import 'package:vitaltracer_app/widgets/sign_up_widget.dart';
import 'package:vitaltracer_app/screens/user_data_config_screen.dart';
import 'forgot_password_screen.dart';

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
    final auth = AuthService();

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserDataConfigScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'lib/images/VTlogo.png',
                  height: 120,
                  width: 120,
                ),
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
                obscureText: false,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              signInSignUpButton(context, true, () async {
                User? user = await AuthService().signInWithEmailAndPassword(
                    emailController.text, passwordController.text);
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserDataConfigScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed')),
                  );
                }
              }),
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
                          builder: (context) => const SignupScreen(),
                        ),
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
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or Continue With',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FloatingActionButton.extended(
                onPressed: () async {
                  bool isLoggedIn = await AuthService().loginWithGoogle();
                  if (isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserDataConfigScreen()),
                    );
                  }
                },
                icon: Image.asset(
                  'lib/images/google.png',
                  height: 32,
                  width: 90,
                ),
                label: const Text('Sign in with Google'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ],
          ),
        ),
      );
    });
  }
}
