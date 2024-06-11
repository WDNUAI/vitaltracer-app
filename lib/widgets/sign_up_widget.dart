import 'package:flutter/material.dart';

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLogin ? Colors.blue : Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        isLogin ? 'Login' : 'Sign Up',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
