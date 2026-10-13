import 'dart:io';

import '../entities/dataset_save_result.dart';
import '../repositories/waste_repository.dart';

class SaveDatasetImage {
  final WasteRepository repository;

  SaveDatasetImage(this.repository);

  Future<DatasetSaveResult> call({
    required File image,
    required String modelPrediction,
    required double confidence,
    required String humanLabel,
  }) {
    return repository.saveDatasetImage(
      image: image,
      modelPrediction: modelPrediction,
      confidence: confidence,
      humanLabel: humanLabel,
    );
  }
}
