class AppConfig {
  final String urlApk = '';

  final Map<String, String> headersApi = {'Content-Type': 'application/x-www-form-urlencoded'};

  final String baseImageApiUrl = 'http://www.zimprov.id/absensi_online/images';
  final String baseApiUrl = 'http://www.zimprov.id/absensi_online/api';

  final String indonesiaLocale = 'id_ID';

  final String userController = 'user_controller';
  final String absensiController = 'absensi_controller';
  final String destinasiController = 'absensi_controller';

  static const defaultImageNetwork = 'https://flutter.io/images/catalog-widget-placeholder.png';
  static const imageLogoAsset = 'assets/images/logo.png';
  static const emptyDestination = 'assets/images/empty_destination.png';

  static const languageID = 'id';
  static const countryCodeID = 'ID';
}

final appConfig = AppConfig();
