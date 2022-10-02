import 'package:flutter/material.dart';

class BrightnessSlider extends StatefulWidget {
  const BrightnessSlider({
    Key? key,
    required this.brightness,
    required this.width,
    required this.onEnded,
  }) : super(key: key);

  final ValueNotifier<double> brightness;

  final VoidCallback onEnded;

  final double width;

  @override
  State<StatefulWidget> createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  final List<Color> _colors = const [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(255, 255, 255, 255),
  ];
  @override
  initState() {
    super.initState();
  }

  _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > widget.width - 9) {
      position = widget.width - 9;
    }
    if (position < 9) {
      position = 9;
    }
    widget.brightness.value = position;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (DragStartDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            onTapDown: (TapDownDetails details) {
              _colorChangeHandler(details.localPosition.dx);
            },
            //This outside padding makes it much easier to grab the   slider because the gesture detector has
            // the extra padding to recognize gestures inside of
            child: Container(
              width: widget.width,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: _colors),
              ),
              child: ValueListenableBuilder(
                valueListenable: widget.brightness,
                builder: (BuildContext context, double value, Widget? child) =>
                    CustomPaint(
                  painter: _SliderIndicatorPainter(widget.brightness.value),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;
  _SliderIndicatorPainter(this.position);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(position, size.height / 2), 9, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_SliderIndicatorPainter old) {
    return true;
  }
}
