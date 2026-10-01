import 'dart:convert';

enum Instrument
{
  sixStringGuitar(6);

  const Instrument(this.stringCount);
  final int stringCount;
}

class Tuning
{
  final String name;
  final int? id;
  final Instrument instrument;
  final List<String> strings;

  const Tuning({this.id,
  required this.name,
  required this.instrument,
  required this.strings});

  Map<String,dynamic> toMap()
  {
    return {'name': name, 'id': id,
    'instrument': instrument.index,
    'strings': jsonEncode(strings)};
  }

  factory Tuning.fromMap(Map<String, dynamic> map)
  {
    return Tuning(name: map['name'] as String,
      id: map['id'] as int?,
      instrument: Instrument.values[map['instrument'] as int],
      strings: List<String>.from(jsonDecode(map['strings'] as String)),
    );
  }
}