import 'dart:io';

import '../entities/dataset_save_result.dart';
import '../entities/dataset_stats.dart';
import '../entities/prediction.dart';

abstract class WasteRepository {
  Future<Prediction> predictWaste(File image);

  Future<DatasetSaveResult> saveDatasetImage({
    required File image,
    required String modelPrediction,
    required double confidence,
    required String humanLabel,
  });

  Future<DatasetStats> getDatasetStats();
}
