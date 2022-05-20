import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/layouts/RoomItem.dart';
import 'package:smarthome/my_icons_icons.dart';
import 'package:smarthome/utils/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Layout();
}

class Layout extends State<Dashboard> {
  final List rooms = [
    {'name': 'add'}
  ];

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

  Container itemContainer(var icon, double size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0x1effffff), Color(0x4affffff)]),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(right: 4),
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: constraints.maxHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
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
                        )),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(top: 50, left: 20),
                      child: Text('Appliances',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 50, right: 5),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50, right: 30),
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(9, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0x12ffffff),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
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
                              '${APPLIANCES.elementAt(index)['energyConsumption']}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xff919191)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
