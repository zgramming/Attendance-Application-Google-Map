import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key key,
  }) : super(key: key);

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
              style: appTheme
                  .headline5(context)
                  .copyWith(fontFamily: 'Righteous', color: colorPallete.black),
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
                        onTap: () => print('Lakukan Update Image Disini'),
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
}
