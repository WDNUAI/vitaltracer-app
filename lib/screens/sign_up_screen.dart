import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/home_screen.dart';
import 'components/custom_textfield.dart';
import 'package:vitaltracer_app/widgets/sign_up_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: const SafeArea(
          child: SignScreenContent(),
        ));
  }
}

class SignScreenContent extends StatelessWidget {
  const SignScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
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
                'Create your account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                ),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                hintText: 'Create Username',
                controller: usernameController,
              ),
              CustomTextField(
                hintText: 'Enter your Email',
                obscureText: true,
                controller: emailController,
              ),
              CustomTextField(
                hintText: 'Create Password',
                controller: passwordController,
              ),
              CustomTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              signInSignUpButton(context, false, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              })
            ],
          ),
        ),
      );
    });
  }
}
