import 'package:tuple/tuple.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import '../../../../providers/user_provider.dart';
import '../../welcome_screen.dart';

class FormUser extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  FormUser({@required this.formKey});
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
          hintText: '',
          radius: 50,
        ),
        SizedBox(height: 20),
        TextFormFieldCustom(
          onSaved: (value) => password = value,
          isPassword: true,
          labelText: 'Password',
          hintText: '',
          radius: 50,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 20),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isRegister,
          builder: (_, isRegister, __) => Visibility(
            visible: isRegister ? true : false,
            child: TextFormFieldCustom(
              onSaved: (value) => fullName = value,
              prefixIcon: Icon(Icons.contacts),
              labelText: 'Full Name',
              hintText: '',
              radius: 50,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
        SizedBox(height: 20),
        Selector2<GlobalProvider, GlobalProvider, Tuple2<bool, bool>>(
          selector: (_, loading, register) => Tuple2(loading.isLoading, register.isRegister),
          builder: (_, value, __) {
            print("Form Login ${value.item1} ${value.item2}");
            return ButtonCustom(
              onPressed: value.item1 ? null : _validate,
              buttonTitle: value.item2 ? " Register" : "Login",
            );
          },
        ),
        SizedBox(height: 20),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isRegister,
          builder: (_, isRegister, __) => OutlineButton(
            child: Text(isRegister ? "Ayo Login" : "Belum Punya Akun ?"),
            onPressed: () => context.read<GlobalProvider>().setRegister(!isRegister),
          ),
        )
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  void _validate() async {
    try {
      if (widget.formKey.currentState.validate()) {
        print("success validate");
        context.read<GlobalProvider>().setLoading(true);
        widget.formKey.currentState.save();
        if (context.read<GlobalProvider>().isRegister) {
          print("ke register");
          final result = await userAPI.userRegister(
            username: username,
            password: password,
            fullName: fullName,
          );

          globalF.showToast(message: result, isSuccess: true, isLongDuration: true);

          context.read<GlobalProvider>().setRegister(false);
          context.read<GlobalProvider>().setLoading(false);
        } else {
          print("ke Login");

          final result = await userAPI.userLogin(
            username: username,
            password: password,
          );
          await context.read<UserProvider>().saveSessionUser(list: result);
          Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
          context.read<GlobalProvider>().setLoading(false);
        }
      } else {
        print("failed validate");
        return null;
      }
    } catch (e) {
      print(e.toString());
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }
}
