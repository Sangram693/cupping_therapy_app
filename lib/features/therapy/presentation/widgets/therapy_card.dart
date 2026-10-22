import 'package:flutter/material.dart';

class TherapyCard extends StatelessWidget {
  const TherapyCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(title)),
    );
  }
}
