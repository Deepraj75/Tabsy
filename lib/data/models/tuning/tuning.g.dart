// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuning.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TuningAdapter extends TypeAdapter<Tuning> {
  @override
  final int typeId = 2;

  @override
  Tuning read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tuning(
      name: fields[0] as String,
      instrument: fields[1] as Instrument,
      strings: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tuning obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.instrument)
      ..writeByte(2)
      ..write(obj.strings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TuningAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstrumentAdapter extends TypeAdapter<Instrument> {
  @override
  final int typeId = 4;

  @override
  Instrument read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Instrument.sixStringGuitar;
      default:
        return Instrument.sixStringGuitar;
    }
  }

  @override
  void write(BinaryWriter writer, Instrument obj) {
    switch (obj) {
      case Instrument.sixStringGuitar:
        writer.writeByte(0);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstrumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
