// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CycleAdapter extends TypeAdapter<Cycle> {
  @override
  final int typeId = 1;

  @override
  Cycle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cycle(
      year: fields[0] as int,
      month: fields[1] as int,
      periodStartDay: fields[2] as int,
      periodLength: fields[3] as int,
      cycleLength: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Cycle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.periodStartDay)
      ..writeByte(3)
      ..write(obj.periodLength)
      ..writeByte(4)
      ..write(obj.cycleLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
