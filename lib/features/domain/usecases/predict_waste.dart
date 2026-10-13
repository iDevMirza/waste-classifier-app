import 'dart:io';

import '../entities/prediction.dart';
import '../repositories/waste_repository.dart';

class PredictWaste {
  final WasteRepository repository;

  PredictWaste(this.repository);

  Future<Prediction> call(File image) {
    return repository.predictWaste(image);
  }
}
