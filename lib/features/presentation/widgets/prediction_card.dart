import 'package:flutter/material.dart';

import '../../../../core/constants/waste_classes.dart';
import '../../domain/entities/prediction.dart';

class PredictionCard extends StatelessWidget {
  final Prediction prediction;

  const PredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final percentage = prediction.confidence * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome, size: 42),

            const SizedBox(height: 12),

            Text(
              'AI Prediction',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            Text(
              WasteClasses.displayName(prediction.predictedClass),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              'Confidence: '
              '${percentage.toStringAsFixed(2)}%',
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(value: prediction.confidence),
          ],
        ),
      ),
    );
  }
}
