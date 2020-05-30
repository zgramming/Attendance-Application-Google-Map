import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:global_template/global_template.dart';

class ShimmerPerformanceMonthly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white60,
      highlightColor: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: sizes.width(context) / 8,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(height: 10, width: 50, color: Colors.white),
                      Container(height: 10, width: 50, color: Colors.white),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(height: 25, width: 50, color: Colors.white),
                      Container(height: 25, width: 50, color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          )
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         Container(height: 10, width: 10, color: Colors.white),
          //         Container(height: 10, width: 10, color: Colors.white),
          //       ],
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         Container(height: 20, width: 20, color: Colors.white),
          //         Container(height: 20, width: 20, color: Colors.white),
          //       ],
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
