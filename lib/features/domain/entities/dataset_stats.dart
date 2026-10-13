import 'package:equatable/equatable.dart';

class DatasetStats extends Equatable {
  final int totalImages;
  final Map<String, dynamic> classes;

  const DatasetStats({required this.totalImages, required this.classes});

  @override
  List<Object?> get props => [totalImages, classes];
}
