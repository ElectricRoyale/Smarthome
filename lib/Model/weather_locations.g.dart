// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_locations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherLocationsAdapter extends TypeAdapter<WeatherLocations> {
  @override
  final int typeId = 1;

  @override
  WeatherLocations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherLocations(
      weatherLocationList: (fields[0] as List?)?.cast<String>(),
      weatherLocation: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherLocations obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.weatherLocationList)
      ..writeByte(1)
      ..write(obj.weatherLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherLocationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
