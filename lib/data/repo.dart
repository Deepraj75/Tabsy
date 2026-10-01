import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Repo {
  static final Repo instance = Repo._instance();
  static Database? _database;

  Repo._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'tabsy.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
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
    FOREIGN KEY (tuningId) REFERENCES tuning(id))''');

    await db.execute('''
    CREATE TABLE Notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tabId INTEGER NOT NULL,
    fret INTEGER NOT NULL,
    gs INTEGET NOT NULL,
    pos INTEGER NOT NULL,
    noteEffect INTEGER NOT NULL,
    noteDuration INTEGER NOT NULL,
    FOREIGN KEY (tabId) REFERENCES tab(id)
    ON DELETE CASCADE)''');

    await db.execute('''CREATE TABLE Tunings
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    instrument INTEGER NOT NULL,
    strings TXT NOT NULL)''');
  }
}
