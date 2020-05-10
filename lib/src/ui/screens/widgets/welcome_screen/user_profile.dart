import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
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
            Consumer<UserProvider>(
              builder: (_, value, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      value.user.fullName,
                      style: appTheme.subtitle2(context),
                    ),
                  ),
                  ShowImageNetwork(
                    imageUrl: "${appConfig.baseImageApiUrl}/user/${value.user.image}",
                    isCircle: true,
                    padding: EdgeInsets.all(20),
                    fit: BoxFit.cover,
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
