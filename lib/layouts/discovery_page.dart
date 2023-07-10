import 'dart:ui';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:smarthome/utils/widget_functions.dart';

import '../generated/l10n.dart';
import '../utils/constants.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  var discoveryList = <BonsoirService>[];
  final _hostController = TextEditingController();
  late BonsoirDiscovery discovery;

  @override
  void initState() {
    super.initState();
    startDiscovery();
  }

  void startDiscovery() async {
    discovery = BonsoirDiscovery(type: '_home-assistant._tcp');
    await discovery.ready;
    discovery.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        setState(() {
          discoveryList.add(event.service!);
        });
      }
    });
    await discovery.start();
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
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
                padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                child: SimpleShadow(
                  offset: const Offset(0, 2),
                  child: Icon(
                    MdiIcons.homeSearch,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  delegate.discoverySelectServer,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0.0, 2.5),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 16.0, left: 130, right: 130),
                child: SimpleShadow(
                  offset: const Offset(0, 2),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 36, 38, 51),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.white,
                    indent: 10,
                    endIndent: 10,
                    thickness: 1.1,
                  ),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20, bottom: 80),
                  itemCount: discoveryList.length,
                  itemBuilder: (context, index) => discoveryItem(
                      discoveryList.elementAt(index).name,
                      discoveryList
                                  .elementAt(index)
                                  .attributes!['external_url'] !=
                              ''
                          ? discoveryList
                              .elementAt(index)
                              .attributes!['external_url']!
                          : discoveryList
                              .elementAt(index)
                              .attributes!['internal_url']!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0, top: 8.0),
                child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (BuildContext context) => manualAddDialog());
                    },
                    child: Text(
                      delegate.discoveryEnterManual,
                      style: const TextStyle(fontSize: 15.0),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget discoveryItem(String name, String host) {
    return InkWell(
      onTap: () {
        discovery.stop();
        Hive.box('Settings').put('host', host);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  host,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, height: 1.6),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget manualAddDialog() {
    return StatefulBuilder(builder: (context, setState) {
      final delegate = S.of(context);
      return BackdropFilter(
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
                    delegate.discoveryDialogMessage,
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
                        controller: _hostController,
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
                          hintText: 'http:ipAddress:8123',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            MdiIcons.ipNetworkOutline,
                            color: Colors.white,
                            size: 30,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
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
                              discovery.stop();
                              Hive.box('Settings')
                                  .put('host', _hostController.text);
                              Navigator.pop(context);
                              Navigator.pop(context);
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
      );
    });
  }
}
