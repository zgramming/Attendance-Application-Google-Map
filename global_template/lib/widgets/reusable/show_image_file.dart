import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class ShowImageFile extends StatelessWidget {
  const ShowImageFile({
    @required this.file,
    this.imageWidth = 2,
    this.imageHeight = 4,
    this.fit,
    this.imageCircleRadius = 35,
    this.isCircle = false,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
  });
  final File file;
  final double imageHeight;
  final double imageWidth;
  final EdgeInsetsGeometry padding;

  ///! Setting Image Circle Radius
  final double imageCircleRadius;

  ///! Setting Align Image
  final AlignmentGeometry alignment;

  ///! Setting Jika Ingin Image Lingkaran
  final bool isCircle;

  ///! Settings fit Image
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = Padding(
      padding: padding,
      child: Image.file(
        file,
        height: sizes.height(context) / imageHeight,
        width: sizes.width(context) / imageWidth,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          print('Error $error || stackTrace $stackTrace');
          return Center(
            child: IconButton(
              icon: const Icon(
                Icons.error,
              ),
              // TODO(ErrorImageFile): Kalau PopUp sudah jadi , implementasikan disini
              onPressed: () => '',
            ),
          );
        },
      ),
    );
    return isCircle
        ? CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: imageCircleRadius,
            child: ClipOval(
              child: image,
            ),
          )
        : image;
  }
}
