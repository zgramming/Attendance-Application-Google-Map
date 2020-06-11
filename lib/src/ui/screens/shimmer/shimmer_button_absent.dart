import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerButtonAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(fit: FlexFit.tight, child: Container(height: 15, color: Colors.white)),
                const SizedBox(width: 10),
                Flexible(fit: FlexFit.tight, child: Container(height: 15, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(fit: FlexFit.tight, child: Container(height: 15, color: Colors.white)),
                const SizedBox(width: 10),
                Flexible(fit: FlexFit.tight, child: Container(height: 15, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
