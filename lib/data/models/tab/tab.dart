import 'package:tabsy/data/models/note/note.dart';
import 'package:tabsy/data/models/tuning/tuning.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'tab.g.dart';

const uuid = Uuid();

@HiveType(typeId:0)
class Tab
{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Tuning tuning;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final int bpm;
  @HiveField(4)
  final int upperFraction;
  @HiveField(5)
  final int lowerFraction;
  @HiveField(6)
  final String artist;
  @HiveField(7)
  final String transcribed;
  @HiveField(8)
  final List<List<Note>> notes;

  Tab({this.name = '',
  this.tuning = Tuning.eStandard,
  String? id,
  this.bpm = 135, this.upperFraction = 4,
  this.lowerFraction = 4,
  this.artist = "Self",
  this.transcribed = "Self",
  List<List<Note>>? notes
  }): id = id?? uuid.v4(),
  notes = notes??
  List.unmodifiable(
    List.generate(
      tuning.instrument.stringCount,
      (_) => const <Note> []
    )
  );

  Tab copyWith({String? name,
  Tuning? tuning,
  int? upperFraction, int? lowerFraction,
  int? bpm, String? artist, String? transcribed,
  List<List<Note>>? notes})
  {
    if (tuning != null)
    {
      if (this.tuning.instrument
      != tuning.instrument)
      {
        tuning = this.tuning;
      }
    }

    return Tab(name:name?? this.name,
    tuning: tuning?? this.tuning,
    id: id, bpm: bpm?? this.bpm,
    upperFraction: upperFraction?? this.upperFraction,
    lowerFraction: lowerFraction?? this.lowerFraction,
    artist: artist?? this.artist,
    transcribed: transcribed?? this.transcribed,
    notes: notes?? this.notes);
  }
}