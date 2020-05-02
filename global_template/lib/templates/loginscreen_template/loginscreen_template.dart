import 'package:flutter/material.dart';

import '../copyright_version_template/copyright_version_template.dart';
import '../../variable/sizes/sizes.dart';
import '../../variable/colors/color_pallete.dart';

class LoginScreenTemplate extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget imageBuilder;
  final List<Widget> formLogin;
  final Widget background;
  final double formOpacity;
  LoginScreenTemplate({
    @required this.formKey,
    @required this.imageBuilder,
    @required this.formLogin,
    @required this.background,
    this.formOpacity = .75,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: background,
          ),
          Container(
            height: sizes.height(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: imageBuilder,
                ),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.white.withOpacity(formOpacity),
                      margin: EdgeInsets.only(
                        left: sizes.width(context) * .05,
                        right: sizes.width(context) * .05,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizes.width(context) * .05,
                          vertical: sizes.height(context) * .025,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: formLogin,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: CopyRightVersion(
                    colorText: colorPallete.white,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
