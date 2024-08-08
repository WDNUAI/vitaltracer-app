import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/skin_color_screen.dart';
import 'package:vitaltracer_app/screens/final_info_screen.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';

class DiseaseScreen extends StatefulWidget {
  const DiseaseScreen({super.key});

  @override
  State<DiseaseScreen> createState() => _DiseaseScreenState();
}

class _DiseaseScreenState extends State<DiseaseScreen> {
  final _formKey = GlobalKey<FormState>();

  final double _topPadding = 20;
  final double _bottomPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, _topPadding, 20, _bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const H1(text: "Disease"),
                const SizedBox(height: 10),
                const H2(text: "Which condition applies to you?"),
                const SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: ListView(
                    children: [
                      SwitchListTile(
                        title: const Text("High Blood Pressure"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Heart Disease"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Asthma"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Stroke"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Cancer"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Diabetes"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Epilepsy"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("High Cholesterol"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Liver Disease"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Thyroid Disease"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Kidney Diseases"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Bones/Joints/Muscle Diseases"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Allergies"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Anxiety"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("Depression"),
                        value: false,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: const Text("HIV/AIDS"),
                        value: false,
                        onChanged: (value) {},
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        Container(
                          height: 18,
                          width: 18,
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
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
                          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
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
                                builder: (context) => const SkinColorScreen()),
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
                                      const FinalInfoScreen()),
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
    );
  }
}
