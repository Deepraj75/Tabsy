import 'dart:convert';

class Tuning
{
  final String name;
  final int? id;
  final List<String> strings;

  const Tuning({this.id,
  required this.name,
  required this.strings});

  Map<String,dynamic> toMap()
  {
    return {'name': name, 'id': id,
    'strings': jsonEncode(strings)};
  }

  factory Tuning.fromMap(Map<String, dynamic> map)
  {
    return Tuning(name: map['name'] as String,
      id: map['id'] as int?,
      strings: List<String>.from(jsonDecode(map['strings'] as String)),
    );
  }
}