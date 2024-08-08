import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'auth_service.dart';
import 'components/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: const SafeArea(
        child: ForgotPasswordContent(),
      ),
    );
  }
}

class ForgotPasswordContent extends StatefulWidget {
  const ForgotPasswordContent({super.key});

  @override
  _ForgotPasswordContentState createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<ForgotPasswordContent> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isButtonDisabled = false;
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _remainingSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _authService.sendPasswordResetEmail(_emailController.text);
      _startTimer();
      _showSnackBar('Password reset email sent. Please check your inbox.');
    } catch (e) {
      _showSnackBar('Failed to send password reset email. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/VTlogo.png',
              height: 120.w,
              width: 120.w,
            ),
            SizedBox(height: 50.h),
            Text(
              'Reset your password',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25.h),
            CustomTextField(
              hintText: 'Enter your email',
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : _sendPasswordResetEmail,
              child: Text(_isButtonDisabled
                  ? 'Resend in $_remainingSeconds seconds'
                  : 'Send Reset Email'),
            ),
            if (_isButtonDisabled) ...[
              SizedBox(height: 20.h),
              Text(
                'Haven\'t received the email? You can resend it in $_remainingSeconds seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 20.w, color: Colors.blue),
                  SizedBox(width: 8.w),
                  Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
