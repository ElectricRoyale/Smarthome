import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/layouts/CarouselSliderItems/deviceGrid.dart';
import 'package:smarthome/layouts/RoomItem.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/weatherData.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../my_icons_icons.dart';
import 'CarouselSliderItems/weather.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Layout();
}

class Layout extends State<Dashboard> {
  DeviceGrid deviceGrid = const DeviceGrid();
  WeatherLayout weather = const WeatherLayout();

  final List rooms = [
    {'name': 'add'}
  ];

  int activeIndex = 2;

  void addItem() {
    setState(() {
      rooms.insert((rooms.length - 1), {
        'icon': 'bed.svg',
        'name': 'Bedroom',
        'appliances': [
          itemContainer(Icons.lightbulb_outline_rounded, 24),
          itemContainer(MyIcons.airConditioner, 23),
        ],
        'energyConsumption': '40 KW USED'
      });
    });
  }

  void setData() async {
    await DashboadData().isInitialized;
    await WeatherData().isInitialized;
    rooms.insertAll(0, DashboadData().getRooms);
    setState(() {});
  }

  @override
  void initState() {
    setData();
    super.initState();
    Future.delayed(const Duration(hours: 1), () async {
      await DashboadData().init();
      await WeatherData().init();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(children: [
          SizedBox(
            width: constraints.maxHeight,
            child: Stack(
              children: [
                Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.25,
                    margin: const EdgeInsets.only(top: 30),
                    child: ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RoomItem(
                          layout: this,
                          roomItem: rooms.elementAt(index),
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: CarouselSlider(
                options: CarouselOptions(
                    height: constraints.maxHeight * 0.55,
                    viewportFraction: 1,
                    initialPage: 2,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index)),
                items: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0x12ffffff),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0x12ffffff),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  deviceGrid,
                  weather,
                  Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0x12ffffff),
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ]),
          ),
          addVerticalSpace(6),
          buildIndicator(),
        ]);
      }),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 5,
        effect: const ScrollingDotsEffect(
            dotHeight: 5, dotWidth: 5, activeDotColor: Colors.white),
        onDotClicked: (index) {
          setState(() => activeIndex = index);
        },
      );
}
