import 'package:flutter/material.dart';

class WidgetTitle extends StatelessWidget {
  final String title;

  WidgetTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}
