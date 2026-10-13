import 'dart:io';

import '../../domain/entities/dataset_save_result.dart';
import '../../domain/entities/dataset_stats.dart';
import '../../domain/entities/prediction.dart';
import '../../domain/repositories/waste_repository.dart';
import '../datasources/waste_remote_data_source.dart';

class WasteRepositoryImpl implements WasteRepository {
  final WasteRemoteDataSource remoteDataSource;

  WasteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Prediction> predictWaste(File image) {
    return remoteDataSource.predictWaste(image);
  }

  @override
  Future<DatasetSaveResult> saveDatasetImage({
    required File image,
    required String modelPrediction,
    required double confidence,
    required String humanLabel,
  }) {
    return remoteDataSource.saveDatasetImage(
      image: image,
      modelPrediction: modelPrediction,
      confidence: confidence,
      humanLabel: humanLabel,
    );
  }

  @override
  Future<DatasetStats> getDatasetStats() {
    return remoteDataSource.getDatasetStats();
  }
}
