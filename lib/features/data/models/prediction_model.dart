import '../../domain/entities/prediction.dart';

class PredictionModel extends Prediction {
  const PredictionModel({
    required super.model,
    required super.predictedClass,
    required super.classIndex,
    required super.confidence,
    required super.probabilities,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    final rawProbabilities = json['probabilities'] as Map<String, dynamic>;

    final probabilities = rawProbabilities.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return PredictionModel(
      model: json['model'] as String,
      predictedClass: json['prediction'] as String,
      classIndex: json['class_index'] as int,
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: probabilities,
    );
  }
}
