import 'package:flutter/material.dart';

import '../../utils/Home_Assistant_Connection.dart';
import '../../utils/constants.dart';
import '../../utils/energy_usage_statistics.dart';
import '../../utils/globals.dart';

class Socket extends StatefulWidget {
  const Socket({Key? key}) : super(key: key);

  @override
  SocketState createState() => SocketState();
}

class SocketState extends State<Socket> {
  bool toggle = deviceItem!.state == 'on';
  double? energy = 0.7;

  @override
  void initState() {
    super.initState();
    onUpdate = () => refresh();
  }

  void refresh() {
    setState(() {
      toggle = deviceItem!.state == 'on';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      toggle = !toggle;
                    });
                    HomeAssistantConnection().send([
                      toggle
                          ? '{"id": ${idNumber++}, "type": "call_service", "domain": "switch", "service": "turn_on", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                          : '{"id": ${idNumber++}, "type": "call_service", "domain": "switch", "service": "turn_off", "target": {"entity_id": "${deviceItem!.entityId}"}}'
                    ]);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0x25ffffff),
                      foregroundColor:
                          const Color(0x25ffffff) // <-- Button color
                      ),
                  child: toggle
                      ? const Icon(
                          Icons.bolt,
                          color: Color.fromARGB(255, 254, 183, 5),
                          size: 60,
                        )
                      : const Icon(
                          Icons.bolt,
                          color: Color.fromARGB(255, 100, 100, 100),
                          size: 60,
                        )),
            ),
            const Divider(
              height: 20,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.white,
            ),
            EnergyUsageStatistics(
              data: deviceItem!,
              padding: const EdgeInsets.only(top: 25),
            ),
          ],
        ),
      ),
    );
  }
}
