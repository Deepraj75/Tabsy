// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TabAdapter extends TypeAdapter<Tab> {
  @override
  final int typeId = 0;

  @override
  Tab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tab(
      name: fields[0] as String,
      tuning: fields[1] as Tuning,
      id: fields[2] as String?,
      bpm: fields[3] as int,
      upperFraction: fields[4] as int,
      lowerFraction: fields[5] as int,
      artist: fields[6] as String,
      transcribed: fields[7] as String,
      notes: (fields[8] as List?)
          ?.map((dynamic e) => (e as List).cast<Note>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Tab obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tuning)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.bpm)
      ..writeByte(4)
      ..write(obj.upperFraction)
      ..writeByte(5)
      ..write(obj.lowerFraction)
      ..writeByte(6)
      ..write(obj.artist)
      ..writeByte(7)
      ..write(obj.transcribed)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
