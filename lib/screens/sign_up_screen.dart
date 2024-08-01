import 'package:flutter/material.dart';
import 'components/custom_textfield.dart';
import 'package:vitaltracer_app/widgets/sign_up_widget.dart';
import 'welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

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
    final TextEditingController confirmPasswordController =
        TextEditingController();
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
                obscureText: false,
                controller: emailController,
              ),
              CustomTextField(
                hintText: 'Create Password',
                obscureText: true,
                controller: passwordController,
              ),
              CustomTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: confirmPasswordController,
              ),
              signInSignUpButton(context, false, () async {
                if (passwordController.text == confirmPasswordController.text) {
                  User? user = await AuthService().registerWithEmailAndPassword(
                      emailController.text, passwordController.text);
                  if (user != null) {
                    // User successfully registered with Firebase Authentication
                    // Now store additional user data in Firestore
                    var db = FirebaseFirestore.instance;

                    final userData = <String, dynamic>{
                      "username": usernameController.text,
                      "email": emailController.text,
                      // Don't store the password in Firestore for security reasons
                    };

                    // Add a new document with the user's UID as the document ID
                    await db.collection("users").doc(user.uid).set(userData);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration failed')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              })
            ],
          ),
        ),
      );
    });
  }
}
