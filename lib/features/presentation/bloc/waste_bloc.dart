import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/usecases/predict_waste.dart';
import '../../domain/usecases/save_dataset_image.dart';
import 'waste_event.dart';
import 'waste_state.dart';

class WasteBloc extends Bloc<WasteEvent, WasteState> {
  final PredictWaste predictWaste;
  final SaveDatasetImage saveDatasetImage;

  WasteBloc({required this.predictWaste, required this.saveDatasetImage})
    : super(const WasteState()) {
    on<WasteImageSelected>(_onImageSelected);
    on<WastePredictionRequested>(_onPredictionRequested);
    on<WasteDatasetSaveRequested>(_onDatasetSaveRequested);
    on<WasteResetRequested>(_onResetRequested);
  }

  void _onImageSelected(WasteImageSelected event, Emitter<WasteState> emit) {
    emit(WasteState(status: WasteStatus.imageSelected, image: event.image));
  }

  Future<void> _onPredictionRequested(
    WastePredictionRequested event,
    Emitter<WasteState> emit,
  ) async {
    final image = state.image;

    if (image == null) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: 'Please select an image first.',
        ),
      );

      return;
    }

    emit(state.copyWith(status: WasteStatus.predicting, clearError: true));

    try {
      final prediction = await predictWaste(image);

      emit(
        state.copyWith(
          status: WasteStatus.predictionSuccess,
          prediction: prediction,
          clearError: true,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: 'Unable to classify the image. $error',
        ),
      );
    }
  }

  Future<void> _onDatasetSaveRequested(
    WasteDatasetSaveRequested event,
    Emitter<WasteState> emit,
  ) async {
    final image = state.image;
    final prediction = state.prediction;

    if (image == null || prediction == null) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: 'No prediction is available to save.',
        ),
      );

      return;
    }

    emit(state.copyWith(status: WasteStatus.saving, clearError: true));

    try {
      final result = await saveDatasetImage(
        image: image,
        modelPrediction: prediction.predictedClass,
        confidence: prediction.confidence,
        humanLabel: event.humanLabel,
      );

      emit(
        state.copyWith(
          status: WasteStatus.saveSuccess,
          saveResult: result,
          clearError: true,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: WasteStatus.failure,
          errorMessage: 'Unable to save the image. $error',
        ),
      );
    }
  }

  void _onResetRequested(WasteResetRequested event, Emitter<WasteState> emit) {
    emit(const WasteState());
  }
}
