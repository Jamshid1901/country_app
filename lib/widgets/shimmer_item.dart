import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItem extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerItem({Key? key, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor:  Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey,
        ),
      ),
    );
  }
}
