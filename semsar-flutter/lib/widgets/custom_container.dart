import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final Widget child;
  final Color? backgroundColor;
  const CustomContainer({
    super.key,
    required this.width,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
      child: child,
    );
  }
}
