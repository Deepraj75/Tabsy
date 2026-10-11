class Folder
{
  int? id;
  String name;

  Folder({this.id, required this.name});

  Map<String,dynamic> toMap()
  {
    return {'id': id,'name': name};
  }

  factory Folder.fromMap(Map<String,dynamic> map)
  {
    return Folder(name: map['name'] as String,
    id: map['id'] as int);
  }
}