import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/dataset_stats.dart';
import '../../domain/usecases/get_dataset_stats.dart';

abstract class DatasetStatsEvent {}

class DatasetStatsRequested extends DatasetStatsEvent {}

abstract class DatasetStatsState {}

class DatasetStatsInitial extends DatasetStatsState {}

class DatasetStatsLoading extends DatasetStatsState {}

class DatasetStatsLoaded extends DatasetStatsState {
  final DatasetStats stats;

  DatasetStatsLoaded(this.stats);
}

class DatasetStatsFailure extends DatasetStatsState {
  final String message;

  DatasetStatsFailure(this.message);
}

class DatasetStatsBloc extends Bloc<DatasetStatsEvent, DatasetStatsState> {
  final GetDatasetStats getDatasetStats;

  DatasetStatsBloc({required this.getDatasetStats})
    : super(DatasetStatsInitial()) {
    on<DatasetStatsRequested>(_onRequested);

    add(DatasetStatsRequested());
  }

  Future<void> _onRequested(
    DatasetStatsRequested event,
    Emitter<DatasetStatsState> emit,
  ) async {
    emit(DatasetStatsLoading());

    try {
      final stats = await getDatasetStats();

      emit(DatasetStatsLoaded(stats));
    } on AppException catch (error) {
      emit(DatasetStatsFailure(error.message));
    } catch (error) {
      emit(DatasetStatsFailure('Unable to load dataset statistics.'));
    }
  }
}
