import 'dart:async';

import 'package:flutter/material.dart';

import 'pointer.dart';

class BrightnessSlider extends StatefulWidget {
  const BrightnessSlider({
    Key? key,
    required this.brightness,
    required this.width,
    required this.onChanged,
    required this.onEnded,
    required this.thumbSize,
  }) : super(key: key);

  final double brightness;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final double width;

  final double thumbSize;

  @override
  State<StatefulWidget> createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider>
    with TickerProviderStateMixin {
  final List<Color> _colors = const [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(255, 255, 255, 255),
  ];

  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      onTap: () => widget.onEnded(),
      child: SizedBox(
        width: widget.width,
        height: widget.thumbSize,
        child: Stack(alignment: Alignment.centerLeft, children: [
          Container(
            width: double.infinity,
            height: 12,
            margin: EdgeInsets.symmetric(
              horizontal: widget.thumbSize / 3,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(colors: _colors),
            ),
          ),
          Positioned(
            left: widget.brightness * (widget.width - widget.thumbSize),
            child: ScaleTransition(
              scale: _scaleController,
              child: Pointer(
                size: widget.thumbSize,
                color: HSLColor.fromAHSL(
                  1,
                  0,
                  0,
                  widget.brightness / 2 + 0.5,
                ).toColor(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onUpdate(DragUpdateDetails details) {
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onEnd(DragEndDetails details) {
    _scaleController.forward();
    widget.onEnded();
  }

  void _onCancel() {
    // ScaleDown Animation cancelled if onDragStart called immediately
    _cancelTimer = Timer(
      const Duration(milliseconds: 5),
      () {
        _scaleController.forward();
        widget.onEnded();
      },
    );
  }
}
