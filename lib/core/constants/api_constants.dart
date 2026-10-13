class ApiConstants {
  ApiConstants._();

  // Android Emulator:
  // static const String baseUrl = 'http://127.0.0.1:8000';
  // static const String baseUrl = 'http://192.168.0.46:8000';
  static const String baseUrl = 'http://172.18.1.253:8000';

  static const String predict = '/predict';
  static const String saveDataset = '/dataset/save';
  static const String datasetStats = '/dataset/stats';
  static const String health = '/health';
}
