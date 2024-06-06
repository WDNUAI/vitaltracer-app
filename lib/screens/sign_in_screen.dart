import 'package:flutter/material.dart';
import 'components/custom_textfield.dart';
import 'user_data_config_screen.dart';

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

    return Center(
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
                  onPressed: () {
                    // Handle forgot password logic
                  },
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserDataConfigScreen()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
