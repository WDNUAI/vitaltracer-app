import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/home_screen.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';
import 'package:vitaltracer_app/widgets/date_selector_widget.dart';

class UserDataConfigScreen extends StatelessWidget {
  const UserDataConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const H1(text: "Welcome"),
              const SizedBox(height: 10),
              const H2(text: "Please provide the following information."),
              const SizedBox(height: 20),
              const H3(text: "Date of Birth"),
              const SizedBox(height: 20),
              const DateSelector(),
              const SizedBox(height: 20),
              const H3(text: "Gender"),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: ListTile(title: Text("Male")),
                  ),
                  Expanded(
                    child: ListTile(title: Text("Female")),
                  ),
                  Expanded(
                      child: ListTile(title: Text("Prefer not to answer"))),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text("Confirm"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
