import 'package:flutter/material.dart' hide Tab;
import 'data/services/repo_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/tab/tab.dart';
import 'data/models/tuning/tuning.dart';
import 'data/models/note/note.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TabAdapter());
  Hive.registerAdapter(TuningAdapter());
  Hive.registerAdapter(InstrumentAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteDurationAdapter());
  Hive.registerAdapter(EffectAdapter());

  await Hive.openBox<Tab>(userTabBox);
  runApp(const MyApp());
}