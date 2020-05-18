import 'package:image_picker/image_picker.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/user_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key key,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild User Profile");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: kToolbarHeight),
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
              builder: (_, value, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      value.fullName,
                      style: appTheme.subtitle2(context),
                    ),
                  ),
                  Stack(
                    children: [
                      InkWell(
                        //TODO Update Image User
                        onTap: _userUpdateImage,
                        borderRadius: BorderRadius.circular(20),
                        child: ShowImageNetwork(
                          imageUrl: value.image.isEmpty
                              ? "https://flutter.io/images/catalog-widget-placeholder.png"
                              : "${appConfig.baseImageApiUrl}/user/${value.image}",
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
                          child: Icon(
                            FontAwesomeIcons.cameraRetro,
                            size: 10,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _userUpdateImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxHeight: 500,
      maxWidth: 600,
    );
    if (imageFile == null) {
      print("Tidak Jadi Mengambil Gambar");
      return null;
    } else {
      try {
        final userProvider = context.read<UserProvider>();
        print("Proses Upload & Update Image ");
        final result = await userProvider.userUpdateImage(userProvider.user.idUser, imageFile);

        print("Proses Update Session User ");
        print("Image Size ${await imageFile.length()}");
        await userProvider.saveSessionUser(list: result);
        globalF.showToast(message: "Berhasil Update Gambar Profile ", isSuccess: true);
      } catch (e) {
        globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      }
    }
  }
}
