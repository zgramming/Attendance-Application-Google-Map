import 'dart:async';
import 'dart:io';

import 'package:global_template/global_template.dart';

class ReusableRequestServer<T> {
  Future<T> requestServer(
    FutureOr<T> requestServer(), {
    Duration durationTimeout = const Duration(seconds: 30),
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = durationTimeout;
      return await requestServer();
    } on FormatException catch (_) {
      throw ConstText.FORMAT_EXCEPTION;
    } on TimeoutException catch (_) {
      throw ConstText.TIMEOUT_EXCEPTION;
    } on SocketException catch (_) {
      throw ConstText.NO_CONNECTION;
    } catch (e) {
      throw e.toString();
    }
  }
}

final ReusableRequestServer<dynamic> reusableRequestServer = ReusableRequestServer<dynamic>();
