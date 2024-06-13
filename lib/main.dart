import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitaltracer_app/screens/sign_in_screen.dart';
import 'models/user_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => UserInfoModel(),
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          title: 'Health Monitor',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const SignScreen(),
        );
      },
    );
  }
}
