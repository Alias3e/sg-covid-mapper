// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitAdapter extends TypeAdapter<Visit> {
  @override
  final int typeId = 0;

  @override
  Visit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Visit()
      ..title = fields[0] as String
      ..latitude = fields[1] as double
      ..longitude = fields[2] as double
      ..checkInTime = fields[3] as DateTime
      ..checkOutTime = fields[7] as DateTime
      ..tags = (fields[4] as List)?.cast<Tag>()
      ..postalCode = fields[5] as String
      ..warningLevel = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Visit obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.checkInTime)
      ..writeByte(7)
      ..write(obj.checkOutTime)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.warningLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
