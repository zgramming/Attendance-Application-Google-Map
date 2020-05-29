class AppConfig {
  final String urlApk = '';

  final Map<String, String> headersApi = {'Content-Type': 'application/x-www-form-urlencoded'};

  final String baseImageApiUrl = 'http://www.zimprov.id/images';
  final String baseFilesApiUrl = 'http://www.zimprov.id/files/';
  final String baseApiUrl = 'http://www.zimprov.id/api/';

  final String indonesiaLocale = 'id_ID';

  final String userController = "user_controller";
  final String absensiController = "absensi_controller";
  final String destinasiController = "absensi_controller";

  static const imageLogoAsset = "assets/images/logo.png";
  static const emptyDestination = "assets/images/empty_destination.png";
}

final appConfig = AppConfig();
