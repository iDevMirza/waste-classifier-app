import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class WasteEvent extends Equatable {
  const WasteEvent();

  @override
  List<Object?> get props => [];
}

class WasteImageSelected extends WasteEvent {
  final File image;

  const WasteImageSelected(this.image);

  @override
  List<Object?> get props => [image.path];
}

class WastePredictionRequested extends WasteEvent {
  const WastePredictionRequested();
}

class WasteDatasetSaveRequested extends WasteEvent {
  final String humanLabel;

  const WasteDatasetSaveRequested({required this.humanLabel});

  @override
  List<Object?> get props => [humanLabel];
}

class WasteResetRequested extends WasteEvent {
  const WasteResetRequested();
}
