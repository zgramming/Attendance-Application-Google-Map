import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/user_provider.dart';

class UserProfilScreen extends StatefulWidget {
  static const routeNamed = '/user-profil-screen';

  @override
  _UserProfilScreenState createState() => _UserProfilScreenState();
}

class _UserProfilScreenState extends State<UserProfilScreen> {
  String fullName;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Selector<GlobalProvider, bool>(
              selector: (_, provider) => provider.isLoading,
              builder: (_, isLoading, __) {
                return isLoading
                    ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
                    : InkWell(
                        onTap: () => _userUpdateFullName(context),
                        child: const Icon(FontAwesomeIcons.check),
                      );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Selector<UserProvider, UserModel>(
          selector: (_, provider) => provider.user,
          builder: (_, user, __) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: Selector<GlobalProvider, bool>(
                      selector: (_, globalProvider) => globalProvider.isImageLoading,
                      builder: (_, isImageLoading, __) {
                        final appConfig2 = appConfig;
                        return isImageLoading
                            ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
                            : Stack(
                                children: [
                                  InkWell(
                                    onTap: () => _userUpdateImage(context),
                                    borderRadius: BorderRadius.circular(40),
                                    child: ShowImageNetwork(
                                      imageUrl: '${appConfig2.baseImageApiUrl}/user/${user.image}',
                                      isCircle: true,
                                      alignment: Alignment.center,
                                      imageCircleRadius: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      backgroundColor: colorPallete.accentColor,
                                      foregroundColor: colorPallete.white,
                                      radius: 20,
                                      child: const Icon(
                                        FontAwesomeIcons.cameraRetro,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: sizes.width(context) / 1.25,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.userCircle),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormFieldCustom(
                              backgroundColor: Colors.transparent,
                              onSaved: (value) => fullName = value,
                              labelText: 'Nama Lengkap',
                              prefixIcon: null,
                              initialValue: user.fullName,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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

  Future<void> _userUpdateFullName(BuildContext context) async {
    final form = _formKey.currentState;
    final userProvider = context.read<UserProvider>();
    final globalProvider = context.read<GlobalProvider>();

    if (form.validate()) {
      form.save();
      try {
        globalProvider.setLoading(true);
        final result = await userProvider.userUpdateFullName(userProvider.user.idUser, fullName);
        await userProvider.saveSessionUser(list: result);
        await globalF.showToast(message: 'Berhasil Update Nama Lengkap', isSuccess: true);
        globalProvider.setLoading(false);
      } catch (e) {
        await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
        globalProvider.setLoading(false);
      }
    } else {
      await globalF.showToast(message: 'Form Tidak Lengkap', isError: true, isLongDuration: true);
    }
  }
}
