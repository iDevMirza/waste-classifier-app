import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/dataset_save_result.dart';
import '../../domain/entities/prediction.dart';

enum WasteStatus {
  initial,
  imageSelected,
  predicting,
  predictionSuccess,
  saving,
  saveSuccess,
  failure,
}

class WasteState extends Equatable {
  final WasteStatus status;
  final File? image;
  final Prediction? prediction;
  final DatasetSaveResult? saveResult;
  final String? errorMessage;

  const WasteState({
    this.status = WasteStatus.initial,
    this.image,
    this.prediction,
    this.saveResult,
    this.errorMessage,
  });

  WasteState copyWith({
    WasteStatus? status,
    File? image,
    Prediction? prediction,
    DatasetSaveResult? saveResult,
    String? errorMessage,
    bool clearPrediction = false,
    bool clearSaveResult = false,
    bool clearError = false,
  }) {
    return WasteState(
      status: status ?? this.status,
      image: image ?? this.image,
      prediction: clearPrediction ? null : prediction ?? this.prediction,
      saveResult: clearSaveResult ? null : saveResult ?? this.saveResult,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    image?.path,
    prediction,
    saveResult,
    errorMessage,
  ];
}
