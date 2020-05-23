import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_template/global_template.dart';
import 'package:http/http.dart' as http;
import 'package:network/network.dart';

class DestinasiApi {
  Future<List<DestinasiModel>> getDestinationById({@required String idUser}) async {
    var result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.get(
          "${appConfig.baseApiUrl}/${appConfig.destinasiController}/destinationById?id_user=$idUser",
        );
        final Map<String, dynamic> responseJson = json.decode(response.body);
        print(responseJson);
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
      throw e;
    }
    return result;
  }

  Future<String> destinationRegister({
    @required String idUser,
    @required String nameDestination,
    @required double latitude,
    @required double longitude,
  }) async {
    var result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final response = await http.post(
            "${appConfig.baseApiUrl}/${appConfig.destinasiController}/destinationRegister",
            body: {
              "id_user": "$idUser",
              "nama_destinasi": "$nameDestination",
              "latitude": "$latitude",
              "longitude": "$longitude",
            });
        final Map<String, dynamic> responseJson = json.decode(response.body);
        if (response.statusCode == 201) {
          return responseJson['message'];
        } else {
          throw responseJson['message'];
        }
      });
    } catch (e) {
      throw e;
    }
    return result;
  }
}

final destinasiAPI = DestinasiApi();
