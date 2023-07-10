import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../generated/l10n.dart';
import '../layouts/room_item.dart';
import '../my_icons_icons.dart';
import '../utils/dashboard_data.dart';
import '../utils/weather_data.dart';
import '../utils/widget_functions.dart';
import 'CarouselSliderItems/device_grid.dart';
import 'CarouselSliderItems/logbook.dart';
import 'CarouselSliderItems/media.dart';
import 'CarouselSliderItems/spotify_control.dart';
import 'CarouselSliderItems/weather.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Layout();
}

class Layout extends State<Dashboard> {
  LogbookLayout logbook = const LogbookLayout();
  MediaLayout media = const MediaLayout();
  DeviceGrid deviceGrid = const DeviceGrid();
  WeatherLayout weather = const WeatherLayout();
  SpotifyControllLayout spotifyControll = const SpotifyControllLayout();

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<String> dayNames = [
        S.of(context).sun,
        S.of(context).mon,
        S.of(context).tue,
        S.of(context).wed,
        S.of(context).thu,
        S.of(context).fri,
        S.of(context).sat,
      ];
      Future.delayed(const Duration(hours: 1), () async {
        await DashboardData()
            .init(S.of(context).devicegridUsage, S.of(context).logbook);
        await WeatherData().init(dayNames);
        setState(() {});
      });
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
          buildIndicator([
            logbook,
            media,
            deviceGrid,
            weather,
            if (DashboardData().getSpotify != null) spotifyControll,
          ].length),
        ]);
      }),
    );
  }

  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: count,
        effect: const ScrollingDotsEffect(
            dotHeight: 5, dotWidth: 5, activeDotColor: Colors.white),
        onDotClicked: (index) {
          setState(() => activeIndex = index);
        },
      );
}
