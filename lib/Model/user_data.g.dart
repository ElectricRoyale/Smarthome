// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

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
      profileImage: fields[0] as Uint8List?,
      name: fields[1] as String,
      token: fields[2] as String,
      email: fields[3] as String,
      birthday: fields[4] as String,
      handyNumber: fields[5] as String,
      address: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.profileImage)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.handyNumber)
      ..writeByte(6)
      ..write(obj.address);
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
