import 'note/note.dart';

class Beat 
{
  final Note? note;
  final int index;
  bool isStart;

  Beat({this.note,this.index = -1
  ,this.isStart = true});
  //-1 is for null note
}