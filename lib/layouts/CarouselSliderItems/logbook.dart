import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:smarthome/utils/dashboard_data.dart';
import 'package:smarthome/utils/logbook_item.dart';

import '../../Model/user_data.dart';
import '../../utils/globals.dart';

class LogbookLayout extends StatefulWidget {
  const LogbookLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LogbookLayoutDesign();
}

class LogbookLayoutDesign extends State<LogbookLayout> {
  List<LogbookItem> logbook = [];

  @override
  void initState() {
    super.initState();
    logbook = DashboardData().getLogbook;
    logbookRefresh = () async => setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    logbookRefresh = () async {};
  }

  Future<void> refreshLog() async {
    List<LogbookItem> log = [];
    Response errorLog = await get(
        Uri.parse('${Hive.box('Settings').get('host')}/api/error_log'),
        headers: {
          'Authorization':
              'Bearer ${Hive.box<UserData>('UserData').values.first.token}',
          'Content-Type': 'application/json'
        });
    RegExp regExp = RegExp(
        r'(?<timestamp>\d+-\d+-\d+ \d+:\d+:\d+\.\d+) (?<status>.+) \(.+\) \[.*?\] (?<message>.+)',
        multiLine: true);
    regExp.allMatches(utf8.decode(errorLog.bodyBytes)).forEach((element) {
      log.add(LogbookItem(
          DateTime.parse('${element.namedGroup('timestamp')!}+00:00').toUtc(),
          element.namedGroup('status')!,
          element.namedGroup('message')!));
    });

    Response stateLog = await get(
        Uri.parse(
            '${Hive.box('Settings').get('host')}/api/logbook/${DateTime.now().subtract(const Duration(hours: 3))}?end_time=${DateTime.now()}'),
        headers: {
          'Authorization':
              'Bearer ${Hive.box<UserData>('UserData').values.first.token}',
          'Content-Type': 'application/json'
        });
    List logs = jsonDecode(utf8.decode(stateLog.bodyBytes));
    for (var value in logs) {
      log.add(LogbookItem(
          DateTime.parse(value['when']).toUtc(),
          'INFO',
          value['state'] != null
              ? (value['name'] + ' changed state to ' + value['state'])
              : (value['name'] + value['message'])));
    }
    log.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    DashboardData().logbook = logbook = log;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0x12ffffff),
          borderRadius: BorderRadius.circular(20.0)),
      clipBehavior: Clip.hardEdge,
      child: RefreshIndicator(
        onRefresh: refreshLog,
        color: Colors.white,
        backgroundColor: const Color(0xff4a4b5e),
        child: ShaderMask(
          shaderCallback: (Rect rect) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey,
              Colors.transparent,
              Colors.transparent,
              Colors.grey,
            ],
            stops: [
              0.0,
              0.035,
              0.965,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect),
          blendMode: BlendMode.dstOut,
          child: ListView.separated(
              itemBuilder: (context, index) => logbook.elementAt(index),
              separatorBuilder: (context, index) => const Divider(
                    color: Colors.white,
                    indent: 10,
                    endIndent: 10,
                    thickness: 1.1,
                  ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: logbook.length),
        ),
      ),
    );
  }
}
