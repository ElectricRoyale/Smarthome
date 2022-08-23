import 'package:flutter/material.dart';

class Pointer extends StatelessWidget {
  const Pointer({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: size - 6,
        height: size - 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(16, 0, 0, 0),
              blurRadius: 4,
              spreadRadius: 4,
            )
          ],
        ),
      ),
    );
  }
}
