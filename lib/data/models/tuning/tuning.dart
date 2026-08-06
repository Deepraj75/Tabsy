import 'package:hive/hive.dart';
part 'tuning.g.dart';

@HiveType(typeId: 4)
enum Instrument
{
  @HiveField(0)
  sixStringGuitar(6);

  const Instrument(this.stringCount);
  final int stringCount;
}


@HiveType(typeId: 2)
class Tuning
{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Instrument instrument;
  @HiveField(2)
  final List<String> strings;

  const Tuning({required this.name,
  required this.instrument,
  required this.strings});

  static const eStandard = 
  Tuning(name: "E Standard",
  instrument: Instrument.sixStringGuitar,
  strings: ['e','B','G','D','A','E']);

  static const dropD =
  Tuning(name: "Drop D",
  instrument: Instrument.sixStringGuitar,
  strings: ['e','B','G','D','A','D']);
}