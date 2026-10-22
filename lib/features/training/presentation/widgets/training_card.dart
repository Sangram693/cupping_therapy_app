import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  const TrainingCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Text(title)),
    );
  }
}
