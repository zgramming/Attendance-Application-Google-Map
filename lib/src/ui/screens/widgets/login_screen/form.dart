import 'package:tuple/tuple.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/user_provider.dart';
import '../../welcome_screen.dart';

class FormUser extends StatefulWidget {
  const FormUser({@required this.formKey});
  final GlobalKey<FormState> formKey;
  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  String username, password, fullName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldCustom(
          onSaved: (value) => username = value,
          disableOutlineBorder: false,
          labelText: 'Username',
          prefixIcon: const Icon(FontAwesomeIcons.userCircle),
          radius: 50,
        ),
        const SizedBox(height: 20),
        TextFormFieldCustom(
          onSaved: (value) => password = value,
          isPassword: true,
          disableOutlineBorder: false,
          labelText: 'Password',
          radius: 50,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 20),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isRegister,
          builder: (_, isRegister, __) {
            return Visibility(
              visible: isRegister ? true : false,
              child: TextFormFieldCustom(
                onSaved: (value) => fullName = value,
                prefixIcon: const Icon(FontAwesomeIcons.user),
                labelText: 'Nama Lengkap',
                disableOutlineBorder: false,
                radius: 50,
                textInputAction: TextInputAction.done,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Selector2<GlobalProvider, GlobalProvider, Tuple2<bool, bool>>(
          selector: (_, loading, register) => Tuple2(loading.isLoading, register.isRegister),
          builder: (_, value, __) {
            return value.item1
                ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
                : ButtonCustom(
                    onPressed: _validate,
                    buttonTitle: value.item2 ? ' Register' : 'Login',
                  );
          },
        ),
        const SizedBox(height: 20),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isRegister,
          builder: (_, isRegister, __) {
            return OutlineButton(
              child: Text(isRegister ? 'Ayo Login' : 'Belum Punya Akun ?'),
              onPressed: () => context.read<GlobalProvider>().setRegister(!isRegister),
            );
          },
        )
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Future<void> _validate() async {
    final globalProvider = context.read<GlobalProvider>();
    final userProvider = context.read<UserProvider>();
    try {
      if (widget.formKey.currentState.validate()) {
        globalProvider.setLoading(true);
        widget.formKey.currentState.save();
        if (globalProvider.isRegister) {
          final result = await userAPI.userRegister(
            username: username,
            password: password,
            fullName: fullName,
          );

          globalProvider.setRegister(false);
          globalProvider.setLoading(false);
          await globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
          print('SUccess Register');
        } else {
          final result = await userAPI.userLogin(
            username: username,
            password: password,
          );
          await userProvider.saveSessionUser(list: result);
          await Future.delayed(const Duration(milliseconds: 500));
          globalProvider.setLoading(false);
          await Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
        }
      } else {
        return;
      }
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      globalProvider.setLoading(false);
    }
  }
}
