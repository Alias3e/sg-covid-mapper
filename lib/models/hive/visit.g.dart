// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitAdapter extends TypeAdapter<Visit> {
  @override
  final typeId = 0;

  @override
  Visit read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Visit()
      ..title = fields[0] as String
      ..latitude = fields[1] as double
      ..longitude = fields[2] as double
      ..checkInTime = fields[3] as DateTime
      ..tags = (fields[4] as List)?.cast<Tag>()
      ..postalCode = fields[5] as String
      ..warningLevel = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Visit obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.checkInTime)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.warningLevel);
  }
}
