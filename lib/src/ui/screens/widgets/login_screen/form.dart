import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';

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
    final GlobalProvider globalProvider = Provider.of(context);
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
        if (globalProvider.isRegister) ...[
          TextFormFieldCustom(
            onSaved: (value) => fullName = value,
            prefixIcon: Icon(Icons.contacts),
            labelText: 'Full Name',
            hintText: '',
            radius: 50,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 20),
        ],
        Consumer<UserProvider>(
          builder: (_, value, __) => ButtonCustom(
            onPressed: globalProvider.isLoading
                ? null
                : () => _validate(userProvider: value, globalProvider: globalProvider),
            buttonTitle: globalProvider.isRegister ? " Register" : "Login",
          ),
        ),
        SizedBox(height: 20),
        OutlineButton(
          child: Text(globalProvider.isRegister ? "Back To Login" : "Don't Have Fake Account ?"),
          onPressed: () => globalProvider.setRegister(!globalProvider.isRegister),
        )
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  void _validate({
    @required UserProvider userProvider,
    @required GlobalProvider globalProvider,
  }) async {
    try {
      if (widget.formKey.currentState.validate()) {
        print("success validate");
        globalProvider.setLoading(true);
        widget.formKey.currentState.save();
        if (globalProvider.isRegister) {
          print("ke register");
          final result = await userApi.userRegister(
            username: username,
            password: password,
            fullName: fullName,
          );

          globalF.showToast(message: result, isSuccess: true, isLongDuration: true);

          globalProvider.setRegister(false);
          globalProvider.setLoading(false);
        } else {
          print("ke Login");

          final result = await userApi.userLogin(
            username: username,
            password: password,
          );
          await userProvider.saveSessionUser(list: result);
          Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
          globalProvider.setLoading(false);
        }
      } else {
        print("failed validate");
        return null;
      }
    } catch (e) {
      print(e.toString());
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      globalProvider.setLoading(false);
    }
  }
}
