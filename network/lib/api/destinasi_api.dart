import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_template/global_template.dart';
import 'package:http/http.dart' as http;
import 'package:network/network.dart';

class DestinasiApi {
  Future<List<DestinasiModel>> getDestinationById({
    @required String idUser,
    String isSelected,
  }) async {
    List<DestinasiModel> result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.get(
          '${appConfig.baseApiUrl}/${appConfig.destinasiController}/destinationById?id_user=$idUser&is_selected=$isSelected',
        );
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (response.statusCode == 200) {
          final List list = responseJson['data'];
          final List<DestinasiModel> destinasiModel =
              list.map((e) => DestinasiModel.fromJson(e)).toList();
          return destinasiModel;
        } else {
          throw responseJson['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<String> destinationRegister({
    @required String idUser,
    @required String nameDestination,
    @required double latitude,
    @required double longitude,
  }) async {
    dynamic result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.post(
            '${appConfig.baseApiUrl}/${appConfig.destinasiController}/destinationRegister',
            body: {
              'id_user': idUser,
              'nama_destinasi': nameDestination,
              'latitude': '$latitude',
              'longitude': '$longitude',
            });
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (response.statusCode == 201) {
          return responseJson['message'];
        } else {
          throw responseJson['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<String> destinationUpdateStatus({
    @required String idDestinasi,
    @required String idUser,
  }) async {
    dynamic result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.post(
          '${appConfig.baseApiUrl}/${appConfig.absensiController}/destinationUpdateStatus',
          body: {
            'id_destinasi': idDestinasi,
            'id_user': idUser,
          },
        );
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (response.statusCode == 200) {
          return responseJson['message'];
        } else {
          throw responseJson['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<String> destinationDelete(String idDestinasi) async {
    dynamic result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.post(
          '${appConfig.baseApiUrl}/${appConfig.absensiController}/destinationDelete',
          body: {'id_destinasi': idDestinasi},
        );
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (response.statusCode == 200) {
          return responseJson['message'];
        } else {
          throw responseJson['message'];
        }
      });
    } catch (e) {
      rethrow;
    }
    return result;
  }
}

final destinasiAPI = DestinasiApi();
