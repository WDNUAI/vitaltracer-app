import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/home_screen.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';
import 'package:vitaltracer_app/widgets/date_selector_widget.dart';

class UserDataConfigScreen extends StatefulWidget {
  const UserDataConfigScreen({super.key});

  @override
  State<UserDataConfigScreen> createState() => _UserDataConfigScreenState();
}

class _UserDataConfigScreenState extends State<UserDataConfigScreen> {
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
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        fillColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        hintText: "Your Height",
                        labelText: "Height",
                        suffixText: "cm",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please specify your height";
                        }

                        int? height = int.tryParse(value);
                        if (height == null) {
                          return "Height must be a number";
                        } else if (height < 40) {
                          return "Height cannot be less than 40cm";
                        } else if (height > 300) {
                          return "Height cannot be higher than 300cm";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        fillColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        hintText: "Your Weight",
                        labelText: "Weight",
                        suffixText: "kg",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please specify your weight";
                        }

                        int? weight = int.tryParse(value);
                        if (weight == null) {
                          return "Weight must be a number";
                        } else if (weight < 10) {
                          return "Weight cannot be less than 10kg";
                        } else if (weight > 500) {
                          return "Weight cannot be higher than 500kg";
                        }

                        return null;
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(250, 40),
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
