class AppConfig {
  String urlApk = '';

  Map<String, String> headersApi = {'Content-Type': 'application/x-www-form-urlencoded'};

  String baseImageApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/images/';
  String baseFilesApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/files/';
  String baseApiUrl = 'https://flutter-absensi.000webhostapp.com/zabsenin/api/';

  String indonesiaLocale = 'id_ID';

  final String userController = "user_controller";
}

final appConfig = AppConfig();
