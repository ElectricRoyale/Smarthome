import 'package:flutter/material.dart';

class CircleColorPickerController extends ChangeNotifier {
  CircleColorPickerController({
    Color initialColor = const Color.fromARGB(255, 255, 0, 0),
  }) : _color = initialColor;

  Color _color;
  Color get color => _color;
  set color(Color color) {
    _color = color;
    notifyListeners();
  }
}
