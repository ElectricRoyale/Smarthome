import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) => SizedBox(
      height: height,
    );

Widget addHorizontalSpace(double width) => SizedBox(
      width: width,
    );

LayoutBuilder itemContainer(IconData icon, double size) {
  return LayoutBuilder(
    builder: (context, constraints) => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0x1effffff), Color(0x4affffff)]),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.01215277),
      margin:
          EdgeInsets.only(right: MediaQuery.sizeOf(context).width * 0.0097222),
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    ),
  );
}
