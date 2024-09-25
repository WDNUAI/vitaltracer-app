import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/sign_in_screen.dart';

/// SplashScreen widget that displays the app logo and transitions to the sign-in screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller to manage the fade-in effect
  late AnimationController _controller;
  // Animation object for the fade-in effect
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration of the fade-in animation
      vsync: this,
    );

    // Create a curved animation for a smooth fade-in effect
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start the animation
    _controller.forward();

    // Delay navigation to the sign-in screen
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the SignScreen and replace the splash screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: FadeTransition(
          opacity: _animation, // Apply the fade-in animation
          child: Image.asset(
            'lib/images/VTlogo.png', // Path to the logo image
            width: 200, // Set the width of the logo
            height: 200, // Set the height of the logo
          ),
        ),
      ),
    );
  }
}
