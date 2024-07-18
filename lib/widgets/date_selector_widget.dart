import 'package:flutter/material.dart';
import 'package:vitaltracer_app/models/user_info.dart';
import 'package:provider/provider.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<UserInfoModel>();
    var birthDate = appState.birthDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 80,
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              appState.setBirthDate(birthDate.year, value + 1, birthDate.day);
            },
            useMagnifier: true,
            magnification: 1.5,
            itemExtent: 50,
            children: const [
              Text("Jan."),
              Text("Feb."),
              Text("Mar."),
              Text("Apr."),
              Text("May"),
              Text("Jun."),
              Text("Jul."),
              Text("Aug."),
              Text("Sep."),
              Text("Oct."),
              Text("Nov."),
              Text("Dec."),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          width: 80,
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              appState.setBirthDate(birthDate.year, birthDate.month, value + 1);
            },
            useMagnifier: true,
            magnification: 1.5,
            itemExtent: 50,
            children: [
              for (int i = 1; i <= 31; i++) Text("$i"),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          width: 80,
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) {
              appState.setBirthDate(
                  value + 1900, birthDate.month, birthDate.day);
            },
            useMagnifier: true,
            magnification: 1.5,
            itemExtent: 50,
            children: [
              for (int i = 1900; i <= 2024; i++) Text("$i"),
            ],
          ),
        ),
      ],
    );
  }
}
