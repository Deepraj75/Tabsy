import 'package:flutter/material.dart' hide Tab;
import 'app.dart';
import 'data/repo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Repo.instance.initDb();
  runApp(const MyApp());
}