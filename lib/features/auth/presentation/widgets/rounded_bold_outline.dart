import 'package:flutter/material.dart';

OutlineInputBorder roundedBoldOutline({
  double radius = 16,
  Color color = const Color(0xFF5E2A25),
  double width = 2.5
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      color: color,
      width: width,
    )
  );
}
