import 'package:flutter/material.dart';

class H3 extends StatelessWidget {
  final String text;

  const H3({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.outline,
    );

    return Text(
      text,
      style: style,
    );
  }
}

class H2 extends StatelessWidget {
  final String text;

  const H2({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    return Text(
      text,
      style: style,
    );
  }
}

class H1 extends StatelessWidget {
  final String text;

  const H1({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.primary,
    );

    return Text(
      text,
      style: style,
    );
  }
}
