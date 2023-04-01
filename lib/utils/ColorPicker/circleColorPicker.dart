import 'package:flutter/material.dart';
import 'package:smarthome/utils/ColorPicker/brightnessSlider.dart';
import 'package:smarthome/utils/widget_functions.dart';

import '../Home_Assistant_Connection.dart';
import '../globals.dart';
import 'colorPickerController.dart';
import 'huePicker.dart';
import 'lightnessSlider.dart';

class CircleColorPicker extends StatefulWidget {
  const CircleColorPicker({
    Key? key,
    this.onChanged,
    this.onEnded,
    this.size = const Size(230, 230),
    this.strokeWidth = 20,
    this.thumbSize = 40,
    this.controller,
    this.child,
    required this.brightness,
  }) : super(key: key);

  final ValueChanged<Color>? onChanged;

  final ValueChanged<Color>? onEnded;

  final CircleColorPickerController? controller;

  final Size size;

  final double strokeWidth;

  final double thumbSize;

  final Widget? child;

  final ValueNotifier<double> brightness;

  Color get initialColor =>
      controller?.color ?? const Color.fromARGB(255, 255, 0, 0);

  double get initialLightness =>
      (HSLColor.fromColor(initialColor).lightness - 0.5) * 2;

  double get initialHue => HSLColor.fromColor(initialColor).hue;

  @override
  State<StatefulWidget> createState() => _CircleColorPickerState();
}

class _CircleColorPickerState extends State<CircleColorPicker>
    with TickerProviderStateMixin {
  late AnimationController _lightnessController;
  late AnimationController _hueController;

  Color get _color {
    return HSLColor.fromAHSL(
      1,
      _hueController.value,
      1,
      (_lightnessController.value / 2 + 0.5),
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width + 90,
      height: widget.size.height + 87,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              HuePicker(
                hue: _hueController.value,
                size: widget.size,
                strokeWidth: widget.strokeWidth,
                thumbSize: widget.thumbSize,
                onEnded: _onEnded,
                onChanged: (hue) {
                  _hueController.value = hue;
                },
              ),
              if (widget.child != null) widget.child!
            ],
          ),
          addVerticalSpace(30),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              ValueListenableBuilder(
                  valueListenable: widget.brightness,
                  builder:
                      (BuildContext context, double value, Widget? child) =>
                          Text(
                            '${brightnessValue.round()}%',
                            style: const TextStyle(color: Colors.white),
                          )),
              Align(
                alignment: Alignment.center,
                child: BrightnessSlider(
                  width: 248,
                  brightness: widget.brightness,
                  onEnded: () {
                    HomeAssistantConnection().send([
                      '{"id": ${idNumber++}, "type": "call_service", "domain" : "light", "service": "turn_on", "service_data" : {"brightness_pct" : "${brightnessValue.round()}"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                    ]);
                  },
                ),
              ),
            ],
          ),
          addVerticalSpace(15),
          Stack(alignment: Alignment.centerLeft, children: [
            Text(
              '${(_lightnessController.value * 100).round()}%',
              style: const TextStyle(color: Colors.white),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: LightnessSlider(
                  width: 260,
                  thumbSize: 26,
                  hue: _hueController.value,
                  lightness: _lightnessController.value,
                  onEnded: _onEnded,
                  onChanged: (lightness) {
                    _lightnessController.value = lightness;
                    setState(() {});
                  },
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  double get brightnessValue =>
      (((widget.brightness.value - 9) / 2.32) + 1).roundToDouble();

  @override
  void initState() {
    super.initState();
    _hueController = AnimationController(
      vsync: this,
      value: widget.initialHue,
      lowerBound: 0,
      upperBound: 360,
    )..addListener(_onColorChanged);
    _lightnessController = AnimationController(
      vsync: this,
      value: widget.initialLightness,
      lowerBound: 0,
      upperBound: 1,
    )..addListener(_onColorChanged);
    widget.controller?.addListener(_setColor);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_setColor);
    super.dispose();
  }

  void _onColorChanged() {
    widget.onChanged?.call(_color);
    widget.controller?.color = _color;
  }

  void _onEnded() {
    widget.onEnded?.call(_color);
  }

  void _setColor() {
    if (widget.controller != null && widget.controller!.color != _color) {
      final hslColor = HSLColor.fromColor(widget.controller!.color);
      _hueController.value = hslColor.hue;
      _lightnessController.value = (hslColor.lightness - 0.5) * 2;
    }
  }
}
