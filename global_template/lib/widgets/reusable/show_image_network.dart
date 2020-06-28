import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class ShowImageNetwork extends StatelessWidget {
  const ShowImageNetwork({
    @required this.imageUrl,
    this.imageCircleRadius = 35,
    this.imageRadius = 10,
    this.imageWidth = 1,
    this.imageHeight = 1,
    this.isCircle = false,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
    this.fit,
  });

  final String imageUrl;

  ///! Setting Tinggi Image berkisar 0-1
  final double imageHeight;

  ///! Setting Width Image Berkisar 0-1
  final double imageWidth;

  ///! Setting Jika Ingin Image Lingkaran
  final bool isCircle;

  ///! Setting Image Circle Radius
  final double imageCircleRadius;

  ///! Setting Image Circle Radius
  final double imageRadius;

  ///! Setting Padding Image
  final EdgeInsetsGeometry padding;

  ///! Setting Align Image
  final AlignmentGeometry alignment;

  ///! Settings fit Image
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(imageRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? 'https://flutter.dev/images/catalog-widget-placeholder.png',
          height: sizes.height(context) / imageHeight,
          width: sizes.width(context) / imageWidth,
          errorWidget: (BuildContext context, String url, dynamic error) {
            print('From Cached Network Image ${error.toString()}');
            print('From Cached Network Image ${url.toString()}');
            return Center(
              child: IconButton(
                icon: const Icon(
                  Icons.error,
                ),
                onPressed: () => '',
              ),
            );
          },
          placeholder: (context, url) => const CircularProgressIndicator(),
          fit: fit,
          alignment: alignment,
        ),
      ),
    );

    return isCircle
        ? CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: imageCircleRadius,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorPallete.black.withOpacity(.5),
                    blurRadius: 2,
                    offset: const Offset(2, 1),
                  ),
                ],
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: fit,
                ),
              ),
            ),
          )
        : image;
  }
}
