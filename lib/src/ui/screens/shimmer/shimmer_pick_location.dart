import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPickLocatation extends StatelessWidget {
  static const sizeIcon = 14.0;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: const CircleAvatar(backgroundColor: Colors.white, radius: 30),
              title: Container(
                height: 10,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 10,
                color: Colors.white,
              ),
              trailing: Wrap(
                spacing: 5,
                children: const <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: sizeIcon,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: sizeIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
