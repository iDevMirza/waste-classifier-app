import '../entities/dataset_stats.dart';
import '../repositories/waste_repository.dart';

class GetDatasetStats {
  final WasteRepository repository;

  GetDatasetStats(this.repository);

  Future<DatasetStats> call() {
    return repository.getDatasetStats();
  }
}
