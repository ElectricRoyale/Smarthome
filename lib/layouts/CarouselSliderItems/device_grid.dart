import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../generated/l10n.dart';
import '../../utils/constants.dart';
import '../../utils/dashboard_data.dart';
import '../../utils/globals.dart';
import '../overview_page.dart';

class DeviceGrid extends StatefulWidget {
  const DeviceGrid({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DeviceGridState();
}

class DeviceGridState extends State<DeviceGrid> {
  @override
  void initState() {
    super.initState();
    deviceGridRefresh = () async => setState(() {});
  }

  @override
  void dispose() {
    deviceGridRefresh = () async {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final delegate = S.of(context);
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: screenSize.width * 0.048611),
                child: Text(delegate.devicegridAppliances,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width * 0.0121527),
                  child: const Icon(CupertinoIcons.add,
                      color: Colors.white,
                      size: 28,
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 2.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width * 0.072916),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OverViewPage(
                          name: delegate.devicegridAllDevices,
                          groupName: 'ALL DEVICES',
                        ),
                        settings: const RouteSettings(name: 'overviewpage'),
                      ),
                    ),
                    child: SimpleShadow(
                      opacity: 1,
                      offset: const Offset(0, 2.0),
                      child: const Icon(
                        CupertinoIcons.square_grid_2x2_fill,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: screenSize.height * 0.027,
                left: screenSize.width * 0.048611,
                right: screenSize.width * 0.048611),
            child: GridView.builder(
              itemCount: 9,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: screenSize.width * 0.0243055,
                mainAxisSpacing: screenSize.height * 0.0109375,
              ),
              itemBuilder: (BuildContext context, int index) => Container(
                decoration: BoxDecoration(
                  color: const Color(0x12ffffff),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OverViewPage(
                        name: (appliances(context, index)['name'])!,
                        groupName: (appliances(context, index)['groupName'])!,
                      ),
                      settings: const RouteSettings(name: 'overviewpage'),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenSize.height * 0.0109,
                            left: screenSize.width * 0.0243055,
                            right: screenSize.width * 0.0243055),
                        child: SimpleShadow(
                          opacity: 0.6,
                          offset: const Offset(0, 2),
                          child: SvgPicture.asset(
                            'assets/${appliances(context, index)['icon']}',
                            height: screenSize.width * 0.15555,
                            width: screenSize.width * 0.15555,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.00765),
                        child: Text(
                          appliances(context, index)['name'],
                          textScaleFactor: 0.83,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        DashboardData().getEnergyList.elementAt(index) +
                            delegate.devicegridUsage,
                        textScaleFactor: 0.83,
                        style: const TextStyle(
                            color: Color(0xff919191),
                            height: double.minPositive),
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
