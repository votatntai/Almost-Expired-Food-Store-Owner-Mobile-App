import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  const SkeletonWidget({Key? key,required this.borderRadius, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Card(
        child: Container(height: height, width: width,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      baseColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.black.withOpacity(0.04),
    );
  }
}
