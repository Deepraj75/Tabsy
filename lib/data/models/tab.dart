import 'note.dart';
import 'tuning.dart';


class Tab {
  final String name;
  final int? id;
  final Tuning? tuning;
  final int noOfStrings;
  final int bpm;
  final int upperFraction;
  final int lowerFraction;
  final String artist;
  final String transcribed;
  final List<List<Note>> notes;

  Tab({
    this.name = '',
    this.id,
    this.tuning,
    this.noOfStrings = 6,
    this.bpm = 135,
    this.upperFraction = 4,
    this.lowerFraction = 4,
    this.artist = "Self",
    this.transcribed = "Self",
    List<List<Note>>? notes,
  }) :
       notes =
           notes ??
           List.unmodifiable(List.generate(noOfStrings, (_) => const <Note>[]));

  Tab copyWith({
    String? name,
    Tuning? tuning,
    int? upperFraction,
    int? lowerFraction,
    int? bpm,
    String? artist,
    String? transcribed,
    List<List<Note>>? notes,
  }) {
    return Tab(
      name: name ?? this.name,
      tuning: tuning ?? this.tuning,
      noOfStrings: noOfStrings,
      id: id,
      bpm: bpm ?? this.bpm,
      upperFraction: upperFraction ?? this.upperFraction,
      lowerFraction: lowerFraction ?? this.lowerFraction,
      artist: artist ?? this.artist,
      transcribed: transcribed ?? this.transcribed,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tuningId': tuning!.id,
      'noOfStrings': noOfStrings,
      'bpm': bpm,
      'upperFraction': upperFraction,
      'lowerFraction': lowerFraction,
      'artist': artist,
      'transcribed': transcribed,
    };
  }

  factory Tab.fromMap(
    Map<String, dynamic> map,
    Tuning tuning,
    List<List<Note>> notes) 
  {
    return Tab(
      id: map['id'] as int?,
      name: map['name'] as String,
      tuning: tuning,
      noOfStrings: map['noOfStrings'] as int,
      bpm: map['bpm'] as int,
      upperFraction: map['upperFraction'] as int,
      lowerFraction: map['lowerFraction'] as int,
      artist: map['artist'] as String,
      transcribed: map['transcribed'] as String,
      notes: notes,
    );
  }
}
