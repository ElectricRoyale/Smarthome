// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const BACKGROUND_START = Color(0xff454549);
const BACKGROUND_END = Color(0xff12172c);
const COLOR_ACCENT = Color(0xff790000);
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
    [Color(0xffffdc00), Color(0xffff0000)],
    [Color(0xff00ffbc), Color(0xff00ffff)]
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

const APPLIANCES = [
  {
    'icon': 'light.svg',
    'name': 'LIGHT',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'socket.svg',
    'name': 'SOCKET',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'shutter.svg',
    'name': 'ROLLER SHUTTER',
    'group': 'cover',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'Air_conditioner.svg',
    'name': 'AIR CONDITIONER',
    'group': 'air_conditioner',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'television.svg',
    'name': 'VIDEO DEVICES',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'heating_system.svg',
    'name': 'HEATING SYSTEM',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'kitchen_tools.svg',
    'name': 'KITCHEN TOOLS',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'washing_machine.svg',
    'name': 'WASHING MACHINE',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
  {
    'icon': 'garden.svg',
    'name': 'IRRIGATION',
    'group': 'switch',
    'energyConsumption': '0 KW USED'
  },
];
