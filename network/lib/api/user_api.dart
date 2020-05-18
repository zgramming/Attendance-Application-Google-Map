import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:network/network.dart';
import 'package:flutter/foundation.dart';
import 'package:global_template/global_template.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<List<UserModel>> userLogin({
    @required String username,
    @required String password,
  }) async {
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

  Future<List<UserModel>> userUpdateImage({
    @required String idUser,
    @required File imageFile,
  }) async {
    List<UserModel> result;
    try {
      result = await reusableRequestServer.requestServer(() async {
        final String _nameFileFromAPI = "file";
        var stream = new http.ByteStream(Stream.castFrom(imageFile.openRead()));
        final length = await imageFile.length();
        final uri = Uri.parse(
          "${appConfig.baseApiUrl}/${appConfig.userController}/userUpdateImage",
        );
        final request = http.MultipartRequest("POST", uri);
        final multipartFile = http.MultipartFile(
          _nameFileFromAPI, //! Nama field yang ada di API
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.fields['id_user'] = idUser;
        request.files.add(multipartFile);
        final response = await request.send();
        final responseString = await response.stream.bytesToString();
        Map<String, dynamic> responseJson = json.decode(responseString);

        int statusCode = response.statusCode;
        if (statusCode == 200) {
          List userList = responseJson['data'];
          List<UserModel> result = userList.map((e) => UserModel.fromJson(e)).toList();
          return result;
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

final userAPI = UserApi();
