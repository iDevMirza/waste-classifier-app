import '../../domain/entities/dataset_stats.dart';

class DatasetStatsModel extends DatasetStats {
  const DatasetStatsModel({
    required super.totalImages,
    required super.classes,
  });

  factory DatasetStatsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawClasses = json['class_distribution'];
    final rawTotal = json['total_images'];

    if (rawClasses is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid dataset statistics response: '
            '"classes" must be a JSON object.',
      );
    }

    if (rawTotal is! num) {
      throw const FormatException(
        'Invalid dataset statistics response: '
            '"total_images" must be a number.',
      );
    }

    final classes = rawClasses.map(
          (key, value) {
        if (value is! num) {
          throw FormatException(
            'Invalid image count for class: $key',
          );
        }

        return MapEntry(
          key,
          value.toInt(),
        );
      },
    );

    return DatasetStatsModel(
      totalImages: rawTotal.toInt(),
      classes: classes,
    );
  }
}