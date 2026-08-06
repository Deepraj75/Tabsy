// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fret: fields[0] as int,
      noteEffect: fields[1] as Effect,
      noteDuration: fields[2] as NoteDuration,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.fret)
      ..writeByte(1)
      ..write(obj.noteEffect)
      ..writeByte(2)
      ..write(obj.noteDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteDurationAdapter extends TypeAdapter<NoteDuration> {
  @override
  final int typeId = 5;

  @override
  NoteDuration read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoteDuration.whole;
      case 1:
        return NoteDuration.half;
      case 2:
        return NoteDuration.quarter;
      default:
        return NoteDuration.whole;
    }
  }

  @override
  void write(BinaryWriter writer, NoteDuration obj) {
    switch (obj) {
      case NoteDuration.whole:
        writer.writeByte(0);
        break;
      case NoteDuration.half:
        writer.writeByte(1);
        break;
      case NoteDuration.quarter:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteDurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EffectAdapter extends TypeAdapter<Effect> {
  @override
  final int typeId = 6;

  @override
  Effect read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Effect.none;
      case 1:
        return Effect.hammerOn;
      case 2:
        return Effect.pullOff;
      case 3:
        return Effect.vibrato;
      case 4:
        return Effect.palmMuted;
      default:
        return Effect.none;
    }
  }

  @override
  void write(BinaryWriter writer, Effect obj) {
    switch (obj) {
      case Effect.none:
        writer.writeByte(0);
        break;
      case Effect.hammerOn:
        writer.writeByte(1);
        break;
      case Effect.pullOff:
        writer.writeByte(2);
        break;
      case Effect.vibrato:
        writer.writeByte(3);
        break;
      case Effect.palmMuted:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
