// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      //profileImage: fields[0] as Uint8List?,
      name: fields[0] as String,
      token: fields[1] as String,
      /*email: fields[2] as String,
      birthday: fields[3] as String,
      handyNumber: fields[4] as String,
      address: fields[5] as String,*/
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(2)
      /*..writeByte(0)
      ..write(obj.profileImage)*/
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.token);
    /*..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.birthday)
      ..writeByte(4)
      ..write(obj.handyNumber)
      ..writeByte(5)
      ..write(obj.address);*/
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
