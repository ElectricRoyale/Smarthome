import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'circleTween.dart';
import 'color_picker_wheel.dart';
import 'pointer.dart';

class HuePicker extends StatefulWidget {
  const HuePicker({
    Key? key,
    required this.hue,
    required this.onChanged,
    required this.onEnded,
    required this.size,
    required this.strokeWidth,
    required this.thumbSize,
  }) : super(key: key);

  final double hue;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final Size size;

  final double strokeWidth;

  final double thumbSize;

  @override
  _HuePickerState createState() => _HuePickerState();
}

class _HuePickerState extends State<HuePicker> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    final minSize = min(widget.size.width, widget.size.height);
    final offset = CircleTween(
      minSize / 2 - widget.thumbSize / 2,
    ).lerp(widget.hue * pi / 180);
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
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.all(
                  widget.thumbSize / 2 - widget.strokeWidth,
                ),
                child: CustomPaint(
                  painter: CirclePickerPainter(widget.strokeWidth),
                ),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: ScaleTransition(
                scale: _scaleController,
                child: Pointer(
                  size: widget.thumbSize,
                  color: HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
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
      duration: Duration(milliseconds: 50),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    _updatePosition(details.localPosition);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    _updatePosition(details.localPosition);
  }

  void _onUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
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

  void _updatePosition(Offset position) {
    final radians = atan2(
      position.dy - widget.size.height / 2,
      position.dx - widget.size.width / 2,
    );
    widget.onChanged(radians % (2 * pi) * 180 / pi);
  }
}
