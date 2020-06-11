import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:global_template/global_template.dart';

class ShimmerTableAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: sizes.height(context) / 20,
                child: Row(
                  children: [
                    Flexible(
                      child: Container(height: 20, color: Colors.white),
                      fit: FlexFit.tight,
                      flex: 2,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Container(height: 20, color: Colors.white),
                      fit: FlexFit.tight,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Container(height: 20, color: Colors.white),
                      fit: FlexFit.tight,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Container(height: 20, color: Colors.white),
                      fit: FlexFit.tight,
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            );
          },
          itemCount: 15),
    );
  }
}
