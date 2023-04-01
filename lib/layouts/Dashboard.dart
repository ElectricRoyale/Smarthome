import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/layouts/RoomItem.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/weatherData.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../my_icons_icons.dart';
import 'CarouselSliderItems/Spotify_controll.dart';
import 'CarouselSliderItems/deviceGrid.dart';
import 'CarouselSliderItems/logbook.dart';
import 'CarouselSliderItems/media.dart';
import 'CarouselSliderItems/weather.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Layout();
}

class Layout extends State<Dashboard> {
  LogbookLayout logbook = LogbookLayout();
  MediaLayout media = MediaLayout();
  DeviceGrid deviceGrid = DeviceGrid();
  WeatherLayout weather = WeatherLayout();
  SpotifyControllLayout spotifyControll = SpotifyControllLayout();

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
    await DashboardData().isInitialized;
    await WeatherData().isInitialized;
    rooms.insertAll(0, DashboardData().getRooms);
    setState(() {});
  }

  @override
  void initState() {
    setData();
    super.initState();
    Future.delayed(const Duration(hours: 1), () async {
      await DashboardData().init();
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
                    enableInfiniteScroll: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    viewportFraction: 1,
                    initialPage: 2,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index)),
                items: [
                  logbook,
                  media,
                  deviceGrid,
                  weather,
                  if (DashboardData().getSpotify != null) spotifyControll,
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
