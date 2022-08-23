import 'dart:async';

import 'package:flutter/material.dart';

import 'pointer.dart';

class LightnessSlider extends StatefulWidget {
  const LightnessSlider({
    Key? key,
    required this.hue,
    required this.lightness,
    required this.width,
    required this.onChanged,
    required this.onEnded,
    required this.thumbSize,
  }) : super(key: key);

  final double hue;

  final double lightness;

  final double width;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final double thumbSize;

  @override
  _LightnessSliderState createState() => _LightnessSliderState();
}

class _LightnessSliderState extends State<LightnessSlider>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

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
      child: SizedBox(
        width: widget.width,
        height: widget.thumbSize,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 12,
              margin: EdgeInsets.symmetric(
                horizontal: widget.thumbSize / 3,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                gradient: LinearGradient(
                  stops: const [0.5, 1],
                  colors: [
                    HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                    HSLColor.fromAHSL(1, widget.hue, 1, 1).toColor(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: widget.lightness * (widget.width - widget.thumbSize),
              child: ScaleTransition(
                scale: _scaleController,
                child: Pointer(
                  size: widget.thumbSize,
                  color: HSLColor.fromAHSL(
                    1,
                    widget.hue,
                    1,
                    widget.lightness / 2 + 0.5,
                  ).toColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
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
