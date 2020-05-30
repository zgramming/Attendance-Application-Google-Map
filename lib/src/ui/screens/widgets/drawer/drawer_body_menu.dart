import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class DrawerBodyMenu extends StatelessWidget {
  final IconData icon;
  final bool singleWordUppercase;
  final Color avatarColor;
  final Color iconColor;
  final String wordUppercase;
  final String subtitle;
  final Function onTap;
  DrawerBodyMenu({
    @required this.subtitle,
    this.onTap,
    this.icon,
    this.avatarColor,
    this.iconColor,
    this.wordUppercase = "",
    this.singleWordUppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    print("Widget : Drawer Body Menu.dart | Selector | Rebuild !");

    var text = Text(
      wordUppercase,
      style: appTheme.headline6(context).copyWith(
            color: colorPallete.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: avatarColor ?? colorPallete.primaryColor,
              child: singleWordUppercase
                  ? text
                  : Icon(
                      icon,
                      color: iconColor ?? colorPallete.white,
                      size: 15,
                    ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 6.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorPallete.greyTransparent),
                  ),
                ),
                child: Text(
                  subtitle,
                  style: appTheme.subtitle2(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
