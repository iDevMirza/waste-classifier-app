import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/theme/app_theme.dart';
import 'features/data/datasources/waste_remote_data_source.dart';
import 'features/data/repositories/waste_repository_impl.dart';
import 'features/domain/usecases/get_dataset_stats.dart';
import 'features/domain/usecases/predict_waste.dart';
import 'features/domain/usecases/save_dataset_image.dart';
import 'features/presentation/bloc/dataset_stats_bloc.dart';
import 'features/presentation/bloc/waste_bloc.dart';
import 'features/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();

  final remoteDataSource = WasteRemoteDataSourceImpl(client: httpClient);

  final repository = WasteRepositoryImpl(remoteDataSource: remoteDataSource);

  final predictWaste = PredictWaste(repository);

  final saveDatasetImage = SaveDatasetImage(repository);

  final getDatasetStats = GetDatasetStats(repository);

  runApp(
    WasteClassifierApp(
      predictWaste: predictWaste,
      saveDatasetImage: saveDatasetImage,
      getDatasetStats: getDatasetStats,
    ),
  );
}

class WasteClassifierApp extends StatelessWidget {
  final PredictWaste predictWaste;

  final SaveDatasetImage saveDatasetImage;

  final GetDatasetStats getDatasetStats;

  const WasteClassifierApp({
    super.key,
    required this.predictWaste,
    required this.saveDatasetImage,
    required this.getDatasetStats,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WasteBloc(
            predictWaste: predictWaste,
            saveDatasetImage: saveDatasetImage,
          ),
        ),

        BlocProvider(
          create: (_) => DatasetStatsBloc(getDatasetStats: getDatasetStats),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Waste Classifier',

        theme: AppTheme.light,

        home: const HomePage(),
      ),
    );
  }
}
