import 'package:equatable/equatable.dart';

class DatasetSaveResult extends Equatable {
  final String message;
  final String filename;
  final String label;
  final String modelPrediction;
  final double confidence;
  final bool predictionCorrect;
  final String path;

  const DatasetSaveResult({
    required this.message,
    required this.filename,
    required this.label,
    required this.modelPrediction,
    required this.confidence,
    required this.predictionCorrect,
    required this.path,
  });

  @override
  List<Object?> get props => [
    message,
    filename,
    label,
    modelPrediction,
    confidence,
    predictionCorrect,
    path,
  ];
}
