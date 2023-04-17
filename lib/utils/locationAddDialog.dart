import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/Model/weatherLocations.dart';
import 'package:smarthome/utils/weatherData.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:weather/weather.dart';

import '../generated/l10n.dart';

class LocationAddDialog extends StatefulWidget {
  final Function(Weather) callback;
  const LocationAddDialog({Key? key, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocationAddDialogState();
}

class LocationAddDialogState extends State<LocationAddDialog> {
  final _nameController = TextEditingController();
  bool error = false;

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return StatefulBuilder(
      builder: (context, setState) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Dialog(
          insetPadding: const EdgeInsets.all(23.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: const Color(0xff4a4b5e),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    delegate.locationadddialogHeading,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                addVerticalSpace(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 275,
                      child: TextField(
                        autofocus: true,
                        controller: _nameController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          hintText: delegate.locationadddialogHint,
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: IconButton(
                            onPressed: () async {
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.best)
                                      .timeout(const Duration(seconds: 5));
                              List<Placemark> test =
                                  await placemarkFromCoordinates(
                                      position.latitude, position.longitude);
                              _nameController.text = test.first.locality!;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          errorText:
                              error ? delegate.locationadddialogError : null,
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        cursorColor: Colors.white,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: const Color(0x66ffffff),
                            borderRadius: BorderRadius.circular(15)),
                        height: 35,
                        child: IconButton(
                            onPressed: () {
                              if (_nameController.text.isNotEmpty) {
                                WeatherData()
                                    .weather
                                    .currentWeatherByCityName(
                                        _nameController.text)
                                    .then((value) {
                                  WeatherLocations location =
                                      Hive.box<WeatherLocations>(
                                              'WeatherLocations')
                                          .get('WeatherLocation')!;
                                  if (!location.weatherLocationList!
                                      .contains(_nameController.text)) {
                                    location.weatherLocationList!
                                        .add(_nameController.text);
                                  }
                                  location.weatherLocation =
                                      _nameController.text;
                                  Hive.box<WeatherLocations>('WeatherLocations')
                                      .put('WeatherLocation', location);
                                  widget.callback.call(value);
                                  Navigator.of(context).pop();
                                },
                                        onError: (_) =>
                                            setState(() => error = true));
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
