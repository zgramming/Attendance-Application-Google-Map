class AppConfig {
  final String urlApk = '';

  final Map<String, String> headersApi = {'Content-Type': 'application/x-www-form-urlencoded'};

  final String baseImageApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/images';
  final String baseFilesApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/files/';
  final String baseApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/api/';

  final String indonesiaLocale = 'id_ID';

  final String userController = "user_controller";
  final String absensiController = "absensi_controller";
  final String destinasiController = "absensi_controller";
}

final appConfig = AppConfig();
