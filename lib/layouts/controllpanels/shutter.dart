

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';
import '../../utils/home_assistant_connection.dart';
import '../../utils/widget_functions.dart';

class Shutter extends StatefulWidget {
  const Shutter({Key? key}) : super(key: key);

  @override
  ShutterState createState() => ShutterState();
}

class ShutterState extends State<Shutter> {
  int selected = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAvailability(context);
    });
    onUpdate = () => refresh();
  }

  void refresh() {
    checkAvailability(context);
    setState(() {
      selected =
          deviceItem!.state == 'opening' || deviceItem!.state == 'closing'
              ? deviceItem!.state == 'opening'
                  ? 1
                  : 3
              : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BACKGROUND_START,
            BACKGROUND_END,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    addHorizontalSpace(1),
                    RotatedBox(
                      quarterTurns: 1,
                      child: AnimatedToggleSwitch<int>.size(
                        current: selected,
                        values: const [1, 2, 3],
                        iconOpacity: 1,
                        indicatorSize: const Size.fromWidth(100),
                        height: 70,
                        iconAnimationType: AnimationType.onHover,
                        indicatorAnimationType: AnimationType.onHover,
                        iconBuilder: (value) {
                          IconData data = Icons.error;
                          switch (value) {
                            case 1:
                              data = CupertinoIcons.back;
                              break;
                            case 2:
                              data = CupertinoIcons.stop_fill;
                              break;
                            case 3:
                              data = CupertinoIcons.forward;
                              break;
                          }
                          return Center(
                            child: Icon(
                              data,
                              size: 40,
                              color: Colors.white,
                            ),
                          );
                        },
                        borderWidth: 0.0,
                        style: const ToggleStyle(
                          borderColor: Colors.transparent,
                          backgroundColor: Color(0x12ffffff),
                        ),
                        styleBuilder: (i) => ToggleStyle(
                            indicatorColor:
                                i.isEven ? Colors.red : Colors.green),
                        onChanged: (index) {
                          setState(() => selected = index);
                          switch (index) {
                            case 1:
                              HomeAssistantConnection().send([
                                '{"id": ${idNumber++}, "type": "call_service", "domain": "cover", "service": "open_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                            case 2:
                              HomeAssistantConnection().send([
                                '{"id": ${idNumber++}, "type": "call_service", "domain": "cover", "service": "stop_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                            case 3:
                              HomeAssistantConnection().send([
                                '{"id": ${idNumber++}, "type": "call_service", "domain": "cover", "service": "close_cover", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                              ]);
                              break;
                          }
                        },
                      ),
                    ),
                    addHorizontalSpace(1),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Stack(alignment: Alignment.center, children: [
                        SvgPicture.asset(
                          'assets/window.svg',
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.scaleDown,
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 50.0, left: 2.0, right: 2.0, bottom: 30.0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(12)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 120,
                                  thumbShape: SliderComponentShape.noOverlay,
                                  overlayShape: SliderComponentShape.noOverlay,
                                  inactiveTrackColor: Colors.transparent,
                                  valueIndicatorShape:
                                      SliderComponentShape.noOverlay,
                                  trackShape:
                                      const GradientRectangularSliderTrackShape(),
                                ),
                                child: Slider(
                                  max: 100.0,
                                  min: 0,
                                  value: 100 -
                                      (deviceItem?.attributes
                                                  ?.currentPosition ??
                                              100.0)
                                          .toDouble(),
                                  onChanged: (double value) => setState(() {
                                    deviceItem!.attributes!.currentPosition =
                                        100 - value.round();
                                  }),
                                  onChangeEnd: (double value) =>
                                      HomeAssistantConnection().send([
                                    '{"id": ${idNumber++}, "type": "call_service", "domain" : "cover", "service": "set_cover_position", "service_data" : {"position" : "${100 - value.round()}"}, "target" : {"entity_id": "${deviceItem!.entityId}"}}'
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${deviceItem?.attributes?.currentPosition ?? 100}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ),
                  ]),
            ),
            Divider(
              height: screenSize.height * 0.021875,
              thickness: screenSize.height * 0.0021875,
              indent: screenSize.width * 0.02431,
              endIndent: screenSize.width * 0.02431,
              color: Colors.white,
            ),
            EnergyUsageStatistics(
              data: deviceItem,
              padding: const EdgeInsets.only(top: 25),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientRectangularSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Creates a slider track that draws 2 rectangles.
  const GradientRectangularSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    LinearGradient gradient = const LinearGradient(colors: [
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
      Color(0xffc3834d),
      Color(0xffc3834d),
      Color(0xff7a5230),
      Color(0xff7a5230),
    ], stops: [
      0.0,
      0.05,
      0.05,
      0.1,
      0.1,
      0.15,
      0.15,
      0.2,
      0.2,
      0.25,
      0.25,
      0.3,
      0.3,
      0.35,
      0.35,
      0.4,
      0.4,
      0.45,
      0.45,
      0.5,
      0.5,
      0.55,
      0.55,
      0.6,
      0.6,
      0.65,
      0.65,
      0.7,
      0.7,
      0.75,
      0.75,
      0.8,
      0.8,
      0.85,
      0.85,
      0.9,
      0.9,
      0.95,
      0.95,
      1
    ]);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect leftTrackSegment = Rect.fromLTRB(
        trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    }
    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    }

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
          begin: sliderTheme.disabledSecondaryActiveTrackColor,
          end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      final Rect secondaryTrackSegment = Rect.fromLTRB(
        (textDirection == TextDirection.ltr)
            ? thumbCenter.dx
            : secondaryOffset.dx,
        trackRect.top,
        (textDirection == TextDirection.ltr)
            ? secondaryOffset.dx
            : thumbCenter.dx,
        trackRect.bottom,
      );
      if (!secondaryTrackSegment.isEmpty) {
        context.canvas.drawRect(secondaryTrackSegment, secondaryTrackPaint);
      }
    }
  }
}
