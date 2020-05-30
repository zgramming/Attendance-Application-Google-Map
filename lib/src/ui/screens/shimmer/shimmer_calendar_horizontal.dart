import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:global_template/global_template.dart';

class ShimmerCalendarHorizontal extends StatelessWidget {
  const ShimmerCalendarHorizontal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        height: sizes.height(context) / 8,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return SizedBox(
              width: sizes.width(context) / 5.5,
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(height: 20, width: 20, color: Colors.white),
                    Container(height: 20, width: 20, color: Colors.white),
                  ],
                ),
              ),
            );
          },
          itemCount: 10,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
