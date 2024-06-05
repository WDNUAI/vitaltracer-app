import 'package:flutter/material.dart';

class HealthDataWidget extends StatelessWidget {
  final String label;
  final String value;

  const HealthDataWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}