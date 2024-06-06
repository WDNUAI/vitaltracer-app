import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitaltracer_app/screens/user_data_config_screen.dart';
import 'models/user_info.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => UserInfoModel(),
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const UserDataConfigScreen(),
    );
  }
}
