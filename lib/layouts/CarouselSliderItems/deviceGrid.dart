import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/DashboardData.dart';
import '../../utils/constants.dart';
import '../OverViewPage.dart';

class DeviceGrid extends StatefulWidget {
  const DeviceGrid({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeviceGridState();
}

class DeviceGridState extends State<DeviceGrid> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                            pageBuilder:
                                (context, animation, secondAnimation) =>
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
            padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
            child: GridView.builder(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              itemCount: 9,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              // Generate 100 widgets that display their index in the List.
              itemBuilder: (BuildContext context, int index) => Container(
                decoration: BoxDecoration(
                  color: const Color(0x12ffffff),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, animation, secondAnimation) =>
                              OverViewPage(
                                name: (APPLIANCES.elementAt(index)['name'])!,
                              ))),
                  borderRadius: BorderRadius.circular(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                          '${DashboadData().getEnergyList.elementAt(index)} kWh USED',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff919191)),
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
    );
  }
}
