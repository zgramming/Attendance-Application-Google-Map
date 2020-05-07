import 'dart:convert';

import 'package:network/network.dart';
import 'package:flutter/foundation.dart';
import 'package:global_template/global_template.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<List<UserModel>> userLogin({@required String username, @required String password}) async {
    var result = await reusableRequestServer.requestServer(() async {
      final response = await http.post(
        '${appConfig.baseApiUrl}/${appConfig.userController}/userLogin',
        headers: appConfig.headersApi,
        body: {
          "username": username,
          "password": password,
        },
      );
      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson["status"] == 1) {
        List userList = responseJson['data'];
        List<UserModel> result = userList.map((e) => UserModel.fromJson(e)).toList();
        return result;
      } else {
        throw responseJson['message'];
      }
    });
    return result;
  }

  Future<String> userRegister({
    @required String username,
    @required String password,
    @required String fullName,
  }) async {
    var result;
    result = await reusableRequestServer.requestServer(() async {
      final response = await http.post(
          '${appConfig.baseApiUrl}/${appConfig.userController}/userRegister',
          headers: appConfig.headersApi,
          body: {
            "username": username,
            "password": password,
            "full_name": fullName,
          });
      final Map<String, dynamic> responseJson = json.decode(response.body);

      return responseJson['message'];
    });
    return result;
  }
}

final userApi = UserApi();
