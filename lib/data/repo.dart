import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class Repo {
  static final Repo instance = Repo._instance();
  static Database? _database;

  Repo._instance();

  Future<Database> get db async {
    return await initDb();
  }

  Future<Database> initDb() async {
    if (_database != null) return _database!;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tabsy.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Tunings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        strings TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Tabs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        tuningId INTEGER NOT NULL,
        noOfStrings INTEGER NOT NULL,
        bpm INTEGER NOT NULL,
        upperFraction INTEGER NOT NULL,
        lowerFraction INTEGER NOT NULL,
        artist TEXT NOT NULL,
        transcribed TEXT NOT NULL,
        FOREIGN KEY (tuningId) REFERENCES Tunings(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tabId INTEGER NOT NULL,
        fret INTEGER NOT NULL,
        gs INTEGER NOT NULL,
        pos INTEGER NOT NULL,
        noteEffect INTEGER NOT NULL,
        noteDuration INTEGER NOT NULL,
        FOREIGN KEY (tabId) REFERENCES Tabs(id)
          ON DELETE CASCADE
      )
    ''');

    await loadTunings(db);
  }

  Future<void> loadTunings(Database db) async {
    final jsonString = await rootBundle.loadString(
      'assets/tunings.json',
    );

    final List<dynamic> data = jsonDecode(jsonString);

    for (final tuning in data) {
      await db.insert('Tunings', {
        'name': tuning['name'],
        'strings': jsonEncode(tuning['strings']),
      });
    }
  }
}