import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late Uint8List? profileImage;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String token;

  @HiveField(3)
  late String email;

  @HiveField(4)
  late String birthday;

  @HiveField(5)
  late String handyNumber;

  @HiveField(6)
  late String address;

  UserData(
      {this.profileImage,
      this.name = 'Unknown',
      this.token = 'Unknown',
      this.email = 'Unknown',
      this.birthday = 'Unknown',
      this.handyNumber = 'Unknown',
      this.address = 'Unknown'});
}
