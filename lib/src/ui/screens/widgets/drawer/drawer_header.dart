import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import '../../../../providers/user_provider.dart';

class DrawerHeaderCustom extends StatelessWidget {
  const DrawerHeaderCustom({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizes.height(context) / 4,
      child: Selector<UserProvider, UserModel>(
        selector: (_, provider) => provider.user,
        builder: (_, value, __) => Stack(
          children: [
            ShowImageNetwork(
              imageUrl: value.image.isEmpty
                  ? "https://flutter.io/images/catalog-widget-placeholder.png"
                  : "${appConfig.baseImageApiUrl}/user/${value.image}",
              fit: BoxFit.cover,
              imageRadius: 0,
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black54),
                child: Text(
                  value.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTheme
                      .subtitle2(context)
                      .copyWith(color: colorPallete.white, fontWeight: FontWeight.bold),
                ),
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
