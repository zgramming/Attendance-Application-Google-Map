import 'package:flutter/material.dart';

class LoadingFutureBuilder extends StatelessWidget {
  const LoadingFutureBuilder({this.isLinearProgressIndicator = false});
  final bool isLinearProgressIndicator;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLinearProgressIndicator
          ? const LinearProgressIndicator()
          : const CircularProgressIndicator(),
    );
  }
}
