import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/user_provider.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Selamat Datang',
              style: appTheme.headline5(context).copyWith(
                    fontFamily: 'Righteous',
                    color: colorPallete.black,
                  ),
            ),
            const SizedBox(height: 10),
            Selector<UserProvider, UserModel>(
              selector: (_, provider) => provider.user,
              builder: (_, value, __) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        value.fullName,
                        style: appTheme.subtitle2(context),
                      ),
                    ),
                    Selector<GlobalProvider, bool>(
                      selector: (_, globalProvider) => globalProvider.isImageLoading,
                      builder: (_, isImageLoading, __) {
                        return isImageLoading
                            ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
                            : Stack(
                                children: [
                                  InkWell(
                                    onTap: () => _userUpdateImage(context),
                                    borderRadius: BorderRadius.circular(20),
                                    child: ShowImageNetwork(
                                      imageUrl: value.image.isEmpty
                                          ? AppConfig.defaultImageNetwork
                                          : '${appConfig.baseImageApiUrl}/user/${value.image}',
                                      isCircle: true,
                                      padding: const EdgeInsets.all(20),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      backgroundColor: colorPallete.accentColor,
                                      foregroundColor: colorPallete.white,
                                      radius: 10,
                                      child: const Icon(
                                        FontAwesomeIcons.cameraRetro,
                                        size: 10,
                                      ),
                                    ),
                                  )
                                ],
                              );
                      },
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _userUpdateImage(BuildContext context) async {
    final _picker = ImagePicker();

    final globalProvider = context.read<GlobalProvider>();
    final userProvider = context.read<UserProvider>();
    final imagePicker = await _picker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxHeight: 500,
      maxWidth: 600,
    );
    if (imagePicker == null) {
      return;
    } else {
      final imageFile = File(imagePicker.path);
      try {
        globalProvider.setImageLoading(true);
        final result = await userProvider.userUpdateImage(userProvider.user.idUser, imageFile);
        await userProvider.saveSessionUser(list: result);
        await globalF.showToast(message: 'Berhasil Update Gambar Profile ', isSuccess: true);
        globalProvider.setImageLoading(false);
      } catch (e) {
        await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
        globalProvider.setImageLoading(false);
      }
    }
  }
}
