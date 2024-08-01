import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/home_screen.dart';
import 'package:vitaltracer_app/screens/disease_screen.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';
import 'package:vitaltracer_app/widgets/yes_no_field.dart';

class FinalInfoScreen extends StatefulWidget {
  const FinalInfoScreen({super.key});

  @override
  State<FinalInfoScreen> createState() => _FinalInfoScreenState();
}

class _FinalInfoScreenState extends State<FinalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final double _topPadding = 20;
  final double _bottomPadding = 20;

  int _gender = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, _topPadding, 20, _bottomPadding),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).vertical -
                    _topPadding -
                    _bottomPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H1(text: "And finally...!"),
                    const SizedBox(height: 10),
                    const YesNoField("Are you a smoker?",
                        "Please specify if you are a smoker."),
                    const SizedBox(height: 10),
                    const YesNoField("Do you drink alcohol?",
                        "Please specify if you drink alcohol."),
                    const SizedBox(height: 10),
                    const YesNoField("Have you ever had any surgery?",
                        "Please specify if you had surgery."),
                    const SizedBox(height: 10),
                    const YesNoField("Do you have a pacemaker?",
                        "Please specify if you have a pacemaker."),
                    const SizedBox(height: 10),
                    const H4(
                        text:
                            "Do you take any medication? If yes, please specify."),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        fillColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        hintText: "Medication",
                        labelText: "Medication",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please specify what medication you take";
                        }
                        return null;
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text("BACK"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DiseaseScreen()),
                              );
                            },
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text("NEXT"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
