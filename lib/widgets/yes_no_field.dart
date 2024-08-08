import 'package:flutter/material.dart';
import 'package:vitaltracer_app/widgets/header_widget.dart';

class YesNoField extends StatelessWidget {
  final String title;
  final String errorText;

  const YesNoField(this.title, this.errorText);

  @override
  Widget build(BuildContext context) {
    bool? _groupValue;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: H4(
            text: title,
          ),
        ),
        FormField(
          builder: (state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: true,
                      groupValue: _groupValue,
                      onChanged: (value) {
                        state.didChange(1);
                        _groupValue = value!;
                      },
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                    ),
                    const Text("Yes"),
                    Radio(
                      value: false,
                      groupValue: _groupValue,
                      onChanged: (value) {
                        state.didChange(1);
                        _groupValue = value!;
                      },
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                    ),
                    const Text("No"),
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
              return errorText;
            }
            return null;
          },
        ),
      ],
    );
  }
}
