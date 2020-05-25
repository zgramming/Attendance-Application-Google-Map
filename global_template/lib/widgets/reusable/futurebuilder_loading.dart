import 'package:flutter/material.dart';

class LoadingFutureBuilder extends StatelessWidget {
  final bool isLinearProgressIndicator;
  LoadingFutureBuilder({this.isLinearProgressIndicator = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLinearProgressIndicator ? LinearProgressIndicator() : CircularProgressIndicator(),
    );
  }
}
