import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId:5)
enum NoteDuration
{
  @HiveField(0)
  whole(240),
  @HiveField(1)
  half(120),
  @HiveField(2)
  quarter(60);
  /* these values are assigned by
  using the value of quarter note
  as 60. 60 is the lcm of 4,3,5
  allowing us to use sixteenth,
  triplets and quintuplets notes
  without dealing with fractions*/

  final int units;

  const NoteDuration(this.units);
}


@HiveType(typeId: 6)
enum Effect
{
  @HiveField(0)
  none,
  @HiveField(1)
  hammerOn,
  @HiveField(2)
  pullOff,
  @HiveField(3)
  vibrato,
  @HiveField(4)
  palmMuted
}


@HiveType(typeId: 1)
class Note
{
  @HiveField(0)
  final int fret;

  @HiveField(1)
  final Effect noteEffect;
  /*based on the stored notes,
  the viewmodel will decide how
  to display this. I didn't
  stored effects as their symbols
  because effects like palm muting
  are denoted by writing them
  below the tab*/

  @HiveField(2)
  final NoteDuration noteDuration;

  Note({this.fret = -1,
  this.noteEffect = Effect.none,
  this.noteDuration = NoteDuration.quarter});
  // -1 represent empty frets

  Note copyWith({int? fret,
  Effect? effect, NoteDuration? duration})
  {
    return Note(fret: fret?? this.fret,
    noteEffect: effect?? noteEffect,
    noteDuration: duration?? noteDuration);
  }
}