import 'package:equatable/equatable.dart';

class Prediction extends Equatable {
  final String model;
  final String predictedClass;
  final int classIndex;
  final double confidence;
  final Map<String, double> probabilities;

  const Prediction({
    required this.model,
    required this.predictedClass,
    required this.classIndex,
    required this.confidence,
    required this.probabilities,
  });

  @override
  List<Object?> get props => [
    model,
    predictedClass,
    classIndex,
    confidence,
    probabilities,
  ];
}
