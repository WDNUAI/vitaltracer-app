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
                    FormField(
                      builder: (state) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    state.didChange(value);
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                ),
                                const Text("Male"),
                                Radio(
                                  value: 2,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    state.didChange(value);
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                ),
                                const Text("Female"),
                                Radio(
                                  value: 3,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    state.didChange(value);
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                ),
                                const Text("Prefer not to answer"),
                              ],
                            ),
                            state.hasError
                                ? Text(
                                    state.errorText!,
                                    style: const TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        184,
                                        54,
                                        44,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                      validator: (int? value) {
                        if (value == null) {
                          return "Please specify your gender";
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
