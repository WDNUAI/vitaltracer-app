import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitaltracer_app/screens/splash_screen.dart';
import 'models/user_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/theme_notifier.dart'; // Import the ThemeNotifier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app with ChangeNotifierProvider for UserInfoModel and ThemeNotifier
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserInfoModel()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()), // Add ThemeNotifier
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the themeNotifier from Provider
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          title: 'Health Monitor',
          //Use theme notifier , set light theme to default
          theme: themeNotifier.isDarkMode ? darkTheme : lightTheme, 
          home: const SplashScreen(),
        );
      },
    );
  }
}
