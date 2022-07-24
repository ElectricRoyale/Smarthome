import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/layouts/OverViewPage.dart';
import 'package:smarthome/layouts/RoomItem.dart';
import 'package:smarthome/utils/DashboardData.dart';
import 'package:smarthome/utils/constants.dart';
import 'package:smarthome/utils/widget_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../my_icons_icons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Layout();
}

class Layout extends State<Dashboard> {
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
          itemContainer(MyIcons.air_conditioner, 23),
        ],
        'energyConsumption': '40 KW USED'
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(hours: 1), () => setState(() => DashboadData().init()));
    rooms.insertAll(0, DashboadData().getRooms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Column(
                    children: [
                      Stack(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text('Appliances',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 29,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondAnimation) =>
                                              const OverViewPage(
                                                name: 'ALL DEVICES',
                                              ))),
                                  child: const Icon(
                                    Icons.grid_view_rounded,
                                    color: Colors.white,
                                    size: 29,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: GridView.builder(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            itemCount: 9,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            // Generate 100 widgets that display their index in the List.
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              decoration: BoxDecoration(
                                color: const Color(0x12ffffff),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondAnimation) =>
                                            OverViewPage(
                                              name: (APPLIANCES
                                                  .elementAt(index)['name'])!,
                                            ))),
                                borderRadius: BorderRadius.circular(20.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: SvgPicture.asset(
                                        'assets/${APPLIANCES.elementAt(index)['icon']}',
                                        height: 64,
                                        width: 64,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Text(
                                        '${APPLIANCES.elementAt(index)['name']}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text(
                                        '${DashboadData().getEnergyList.elementAt(index)} KWh USED',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff919191)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
            dotHeight: 5,
            dotWidth: 5,
            fixedCenter: true,
            activeDotColor: Colors.white),
        onDotClicked: (index) {
          setState(() => activeIndex = index);
        },
      );
}
