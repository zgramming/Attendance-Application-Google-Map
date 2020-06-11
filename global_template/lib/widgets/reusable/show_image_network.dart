import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class ShowImageNetwork extends StatelessWidget {
  final Key key;

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
  ShowImageNetwork({
    @required this.imageUrl,
    this.key,
    this.imageCircleRadius = 35,
    this.imageRadius = 10,
    this.imageWidth = 1,
    this.imageHeight = 1,
    this.isCircle = false,
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
    this.fit,
  });
  @override
  Widget build(BuildContext context) {
    final image = Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(imageRadius),
        child: CachedNetworkImage(
          key: key,
          imageUrl: imageUrl ?? "https://flutter.dev/images/catalog-widget-placeholder.png",
          height: sizes.height(context) / imageHeight,
          width: sizes.width(context) / imageWidth,
          errorWidget: (BuildContext context, String url, dynamic error) {
            print('From Cached Network Image ${error.toString()}');
            print('From Cached Network Image ${url.toString()}');
            return Center(
              child: IconButton(
                icon: Icon(
                  Icons.error,
                ),
                //TODO Kalau PopUp sudah jadi , implementasikan disini
                onPressed: () => '',
              ),
            );
          },
          placeholder: (context, url) => CircularProgressIndicator(),
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
                    offset: Offset(2, 1),
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
