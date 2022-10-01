import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'UserData.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late Uint8List? profileImage;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String birthday;

  @HiveField(4)
  late String handyNumber;

  @HiveField(5)
  late String address;

  UserData(
      {required this.profileImage,
      this.name = 'Unknown',
      this.email = 'Unknown',
      this.birthday = 'Unknown',
      this.handyNumber = 'Unknown',
      this.address = 'Unknown'});
}
