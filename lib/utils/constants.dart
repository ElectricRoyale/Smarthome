// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/l10n.dart';

const BACKGROUND_START = Color(0xff454549);
const BACKGROUND_END = Color(0xff12172c);
const COLOR_ACCENT = Color(0xffb40000);
const COLOR_BLACK = Colors.black;
const COLOR_WHITE = Colors.white;

const Map<String, List<List<Color>>> BackgroundRoomMap = {
  'bed.svg': [
    [
      Color(0xff3A64FA),
      Color(0xff000667),
    ],
    [Color(0xff00C385), Color(0xff44FF00)]
  ],
  'garden_icon.svg': [
    [Color(0xff00ff00), Color(0xff227902)],
    [
      Color(0xff3A64FA),
      Color(0xff000667),
    ],
  ],
  'kitchen.svg': [
    [Color(0xff8c0202), Color(0xffe76500)],
    [Color(0xffb7b7b7), Color(0xff363636)]
  ],
  'bathroom.svg': [
    [Color(0xffd394ff), Color(0xff8500ff)],
    [Color(0xff00ff00), Color(0xff008800)]
  ],
  'livingroom.svg': [
    [Color(0xffffff00), Color(0xffff5000)],
    [Color(0xff00eaff), Color(0xff59ff88)]
  ],
  'cellar.svg': [
    [Color(0xff8d8d8d), Color(0xff363636)],
    [Color(0xffffe619), Color(0xffffa005)]
  ]
};

Map APPLIANCES(BuildContext context, int index) {
  List appliances = [
    {
      'icon': 'light.svg',
      'name': S.of(context).appliancesLight,
      'groupName': 'LIGHT',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'socket.svg',
      'name': S.of(context).appliancesSocket,
      'groupName': 'SOCKET',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'shutter.svg',
      'name': S.of(context).appliancesShutter,
      'groupName': 'ROLLER SHUTTER',
      'group': 'cover',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'Air_conditioner.svg',
      'name': S.of(context).appliancesAirConditioner,
      'groupName': 'AIR CONDITIONER',
      'group': 'air_conditioner',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'television.svg',
      'name': S.of(context).appliancesVideoDevices,
      'groupName': 'VIDEO DEVICES',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'heating_system.svg',
      'name': S.of(context).appliancesHeatingSystem,
      'groupName': 'HEATING SYSTEM',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'kitchen_tools.svg',
      'name': S.of(context).appliancesKitchenTools,
      'groupName': 'KITCHEN TOOLS',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'washing_machine.svg',
      'name': S.of(context).appliancesWashingMachine,
      'groupName': 'WASHING MACHINE',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
    {
      'icon': 'garden.svg',
      'name': S.of(context).appliancesIrrigation,
      'groupName': 'IRRIGATION',
      'group': 'switch',
      'energyConsumption': '0 KW USED'
    },
  ];
  return appliances.elementAt(index);
}

final List<String> effectNames = [
  'none',
  'blue_fade',
  'blue_strobe',
  'colorjump',
  'colorloop',
  'colorstrobe',
  'cyan_fade',
  'cyan_strobe',
  'gb_cross_fade',
  'green_fade',
  'green_strobe',
  'purple_fade',
  'purple_strobe',
  'rb_cross_fade',
  'red_fade',
  'red_strobe',
  'rg_cross_fade',
  'white_fade',
  'white_strobe',
  'yellow_fade',
  'yellow_strobe'
];
final Map<String, Widget> dropdownItems = {
  'none': const SizedBox(
    width: 24,
    height: 24,
  ),
  'blue_fade': SvgPicture.asset(
    'assets/blue_fade.svg',
    width: 24,
    height: 24,
  ),
  'blue_strobe': SvgPicture.asset(
    'assets/blue_strobe.svg',
    width: 24,
    height: 24,
  ),
  'colorjump': SvgPicture.asset(
    'assets/colorjump.svg',
    width: 24,
    height: 24,
  ),
  'colorloop': SvgPicture.asset(
    'assets/colorloop.svg',
    width: 24,
    height: 24,
  ),
  'colorstrobe': SvgPicture.asset(
    'assets/colorstrobe.svg',
    width: 24,
    height: 24,
  ),
  'cyan_fade': SvgPicture.asset(
    'assets/cyan_fade.svg',
    width: 24,
    height: 24,
  ),
  'cyan_strobe': SvgPicture.asset(
    'assets/cyan_strobe.svg',
    width: 24,
    height: 24,
  ),
  'gb_cross_fade': SvgPicture.asset(
    'assets/gb_cross_fade.svg',
    width: 24,
    height: 24,
  ),
  'green_fade': SvgPicture.asset(
    'assets/green_fade.svg',
    width: 24,
    height: 24,
  ),
  'green_strobe': SvgPicture.asset(
    'assets/green_strobe.svg',
    width: 24,
    height: 24,
  ),
  'purple_fade': SvgPicture.asset(
    'assets/purple_fade.svg',
    width: 24,
    height: 24,
  ),
  'purple_strobe': SvgPicture.asset(
    'assets/purple_strobe.svg',
    width: 24,
    height: 24,
  ),
  'rb_cross_fade': SvgPicture.asset(
    'assets/rb_cross_fade.svg',
    width: 24,
    height: 24,
  ),
  'red_fade': SvgPicture.asset(
    'assets/red_fade.svg',
    width: 24,
    height: 24,
  ),
  'red_strobe': SvgPicture.asset(
    'assets/red_strobe.svg',
    width: 24,
    height: 24,
  ),
  'rg_cross_fade': SvgPicture.asset(
    'assets/rg_cross_fade.svg',
    width: 24,
    height: 24,
  ),
  'white_fade': SvgPicture.asset(
    'assets/white_fade.svg',
    width: 24,
    height: 24,
  ),
  'white_strobe': SvgPicture.asset(
    'assets/white_strobe.svg',
    width: 24,
    height: 24,
  ),
  'yellow_fade': SvgPicture.asset(
    'assets/yellow_fade.svg',
    width: 24,
    height: 24,
  ),
  'yellow_strobe': SvgPicture.asset(
    'assets/yellow_strobe.svg',
    width: 24,
    height: 24,
  ),
};
