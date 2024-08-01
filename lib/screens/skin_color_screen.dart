import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/welcome_screen.dart';
import 'package:vitaltracer_app/screens/disease_screen.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';

class SkinColorScreen extends StatefulWidget {
  const SkinColorScreen({super.key});

  @override
  State<SkinColorScreen> createState() => _SkinColorScreenState();
}

class _SkinColorScreenState extends State<SkinColorScreen> {
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
                    const H1(text: "Skin Color"),
                    const SizedBox(height: 10),
                    const H2(
                        text:
                            "Please classify your skin color according to this scale."),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 450,
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("Light, Pale White"),
                            subtitle: const Text("Always burns, never tans"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 255, 222, 199),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("White, Fair"),
                            subtitle: const Text(
                                "Usually burns, tans with difficulty"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 234, 184, 146),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("Medium White to Olive"),
                            subtitle: const Text(
                                "Sometimes mild burn, gradually tans to olive"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 204, 142, 105),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("Olive tone"),
                            subtitle: const Text(
                                "Rarely burns, tans with ease to moderate brown"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 171, 116, 87),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("Light Brown"),
                            subtitle: const Text(
                                "Very rarely burns, tans very easily"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 134, 59, 8),
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: 1,
                              onChanged: (value) {},
                            ),
                            title: const Text("Dark Brown"),
                            subtitle: const Text(
                                "Never burns, tans very easily, deeply pigmented"),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 64, 40, 30),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
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
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                        const WelcomeScreen()),
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
                                      builder: (context) =>
                                          const DiseaseScreen()),
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
