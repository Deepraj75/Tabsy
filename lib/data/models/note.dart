enum Duration
{
  whole(240),
  half(120),
  quarter(60);
  /* these values are assigned by
  using the value of quarter note
  as 60. 60 is the lcm of 4,3,5
  allowing us to use sixteenth,
  triplets and quintuplets notes
  without dealing with fractions*/

  final int units;
  const Duration(this.units);
}

enum Effect
{
  none,
  hammerOn,
  pullOff,
  vibrato,
  palmMuted
}

class Note
{
  final int fret;
  final int? id;
  final Duration noteDuration;
  final Effect noteEffect;
  /*based on the stored notes,
  the viewmodel will decide how
  to display this. I didn't
  stored effects as their symbols
  because effects like palm muting
  are denoted by writing them
  below the tab*/

  Note({this.fret = -1,
  this.id,
  this.noteEffect = Effect.none,
  this.noteDuration = Duration.quarter});
  // -1 represent empty notes

  Note copyWith({int? fret,
  Effect? effect, Duration? duration})
  {
    return Note(fret: fret?? this.fret, id: id,
    noteEffect: effect?? noteEffect,
    noteDuration: duration?? noteDuration);
  }

  Map<String,dynamic> toMap()
  {
    return {'fret':fret,'noteEffect': noteEffect.index,
    'noteDuration': noteDuration.index};
  }

  factory Note.fromMap(Map<String,dynamic> map)
  {
    return Note(fret:map['fret'] as int,
    id: map['id'] as int?,
    noteEffect: Effect.values[map['noteEffect'] as int],
    noteDuration: Duration.values[map['noteDuration'] as int]);
  }
}