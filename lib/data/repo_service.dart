import 'repo.dart';
//import 'models/note.dart';
import 'models/tuning.dart';
import 'models/tab.dart';
import 'package:sqflite/sqflite.dart';

class RepoService {
  static final RepoService instance = RepoService._();

  RepoService._();

  Future<Tuning?> getTuning(int id) async
  {
    Database database = await Repo.instance.db;
    final result = await database.query('Tunings',
    where: 'id = ?',whereArgs: [id]);

    if (result.isEmpty) return null;

    return Tuning.fromMap(result.first);
  }

  Future<List<Tuning>> getAllTunings() async
  {
    final database = await Repo.instance.db;
    final results = await database.query('Tunings');

    List<Tuning> tunings = [];
    for (Map<String,dynamic> result in results)
    {
      tunings.add(Tuning.fromMap(result));
    }

    return tunings;
  }

  Future<void> insertAllnotes(Database database, Tab tab) async
  {
    for (int i = 0; i < tab.notes.length; ++i)
    {
      for (int j = 0; j < tab.notes[i].length; ++j)
      {
        Map<String,dynamic> result = tab.notes[i][j].toMap();
        result['gs'] = i;
        result['pos'] = j;
        result['tabId'] = tab.id;

        await database.insert('notes', result);
      }
    }
  }

  Future<void> deleteAllnotes(Database database, Tab tab) async
  {
    await database.delete(
    'Notes',
    where: 'tabId = ?',
    whereArgs: [tab.id],
  );
  }

  Future<int> saveTab(int? tabId, Tab tab) async
  {
    final database = await Repo.instance.db;

    if (tabId == null)
    {
      return database.insert('Tabs',
      tab.toMap());
    }

    await database.update('Tabs',tab.toMap(),where: 'id = ?',
    whereArgs: [tab.id]);

    await insertAllnotes(database,tab);
    await deleteAllnotes(database,tab);

    return tab.id!;
  }

  Future<int> deleteTab(int tabId) async
  {
    final database = await Repo.instance.db;
    
    return database.delete('Tabs',where:'id = ?',whereArgs: [tabId]);
  }

  Future<List<List<String>>> getAllTabs() async
  {
    final database = await Repo.instance.db;

    final result = await database.rawQuery(
      ''' SELECT Tabs.name as tabName, Tunings.name as tuningName,
      Tabs.id FROM Tabs JOIN Tunings ON Tabs.tuningId = Tunings.id'''
    );
    List<List<String>> tabs = [];

    for (final row in result)
    {
      tabs.add([row['tabName'] as String,
      row['tuningName'] as String,
      row['id'] as String]);
    }

    return tabs;
  }

  Future<Tab> readTab(int tabId) async
  {
    final database = await Repo.instance.db;

    final tabDetails = await database.query('Tabs', where:'id = ?',
    whereArgs:[tabId]);

    final tuningDetails = await database.query('Tunings', where:'id = ?',
    whereArgs:[tabDetails['tuningId' as int]]);

    //
  }
}