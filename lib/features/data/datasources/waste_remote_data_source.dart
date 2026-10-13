import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../models/dataset_save_model.dart';
import '../models/dataset_stats_model.dart';
import '../models/prediction_model.dart';

abstract class WasteRemoteDataSource {
  Future<PredictionModel> predictWaste(File image);

  Future<DatasetSaveModel> saveDatasetImage({
    required File image,
    required String modelPrediction,
    required double confidence,
    required String humanLabel,
  });

  Future<DatasetStatsModel> getDatasetStats();
}

class WasteRemoteDataSourceImpl implements WasteRemoteDataSource {
  final http.Client client;

  WasteRemoteDataSourceImpl({required this.client});

  @override
  Future<PredictionModel> predictWaste(File image) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.predict}');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamedResponse = await client.send(request);

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return PredictionModel.fromJson(json);
    }

    throw AppException(_extractError(response));
  }

  @override
  Future<DatasetSaveModel> saveDatasetImage({
    required File image,
    required String modelPrediction,
    required double confidence,
    required String humanLabel,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.saveDataset}',
    );

    final request = http.MultipartRequest('POST', uri);

    // Attach the JPEG image with the correct MIME type.
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.fields.addAll({
      'model_prediction': modelPrediction,
      'confidence': confidence.toString(),
      'human_label': humanLabel,
    });

    final streamedResponse = await client.send(request);

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    debugPrint('SAVE STATUS: ${response.statusCode}');
    debugPrint('SAVE RESPONSE: ${response.body}');

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final json = jsonDecode(response.body)
      as Map<String, dynamic>;

      return DatasetSaveModel.fromJson(json);
    }

    throw AppException(_extractError(response));
  }

  @override
  Future<DatasetStatsModel> getDatasetStats() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.datasetStats}',
    );

    try {
      debugPrint('Fetching dataset statistics: $uri');

      final response = await client.get(uri).timeout(
        const Duration(seconds: 20),
      );

      debugPrint('STATS STATUS: ${response.statusCode}');
      debugPrint('STATS RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)
        as Map<String, dynamic>;

        return DatasetStatsModel.fromJson(json);
      }

      throw AppException(
        _extractError(response),
      );
    } catch (error) {
      debugPrint('STATS ERROR: $error');
      rethrow;
    }
  }

  String _extractError(http.Response response) {
    try {
      final json = jsonDecode(response.body);

      if (json is Map<String, dynamic> && json['detail'] != null) {
        return json['detail'].toString();
      }
    } catch (_) {
      // Ignore JSON parsing failure.
    }

    return 'Request failed with status '
        '${response.statusCode}.';
  }
}
