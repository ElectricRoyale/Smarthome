import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) => SizedBox(
      height: height,
    );

Widget addHorizontalSpace(double width) => SizedBox(
      width: width,
    );

Container itemContainer(IconData icon, double size) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0x1effffff), Color(0x4affffff)]),
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(3),
    margin: const EdgeInsets.only(right: 4),
    child: Icon(
      icon,
      color: Colors.white,
      size: size,
    ),
  );
}
