class AppConfig {
  String urlApk = '';

  Map<String, String> headersApi = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  String baseImageApiUrl = '';
  String baseFilesApiUrl = '';
  String baseApiUrl = '';
  String indonesiaLocale = 'id_ID';
}

final appConfig = AppConfig();
