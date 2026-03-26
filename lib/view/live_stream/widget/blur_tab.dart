import 'package:flutter/material.dart';

class BlurTab extends StatelessWidget {
  final Widget child;
  final double height;
  final double radius;

  const BlurTab(
      {Key? key, required this.child, this.height = 50, this.radius = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}
