import '../../domain/entities/dataset_save_result.dart';

class DatasetSaveModel extends DatasetSaveResult {
  const DatasetSaveModel({
    required super.message,
    required super.filename,
    required super.label,
    required super.modelPrediction,
    required super.confidence,
    required super.predictionCorrect,
    required super.path,
  });

  factory DatasetSaveModel.fromJson(Map<String, dynamic> json) {
    return DatasetSaveModel(
      message: json['message'] as String,
      filename: json['filename'] as String,
      label: json['label'] as String,
      modelPrediction: json['model_prediction'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      predictionCorrect: json['prediction_correct'] as bool,
      path: json['path'] as String,
    );
  }
}
