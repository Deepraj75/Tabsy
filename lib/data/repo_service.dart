import 'repo.dart';
import 'models/note.dart';
import 'models/tuning.dart';
import 'models/tab.dart';

class RepoService {
  static final RepoService instance = RepoService._();

  RepoService._();

  Future<Tuning?> getTuning(int id) async {
    final database = await Repo.instance.db;
    final result = await database.query(
      'Tunings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;

    return Tuning.fromMap(result.first);
  }

  Future<List<Tuning>> getAllTunings() async {
    final database = await Repo.instance.db;
    final results = await database.query('Tunings');

    return results.map(Tuning.fromMap).toList();
  }

  /// Inserts or updates the tab and replaces all of its notes atomically.
  /// Returns the tab's id (new id for inserts).
  Future<int> saveTab(Tab tab) async {
    final database = await Repo.instance.db;

    return database.transaction((txn) async {
      final int id;

      if (tab.id == null) {
        id = await txn.insert('Tabs', tab.toMap());
      } else {
        id = tab.id!;
        await txn.update(
          'Tabs',
          tab.toMap(),
          where: 'id = ?',
          whereArgs: [id],
        );
        await txn.delete('Notes', where: 'tabId = ?', whereArgs: [id]);
      }

      final batch = txn.batch();
      for (int i = 0; i < tab.notes.length; ++i) {
        for (int j = 0; j < tab.notes[i].length; ++j) {
          batch.insert('Notes', {
            ...tab.notes[i][j].toMap(),
            'gs': i,
            'pos': j,
            'tabId': id,
          });
        }
      }
      await batch.commit(noResult: true);

      return id;
    });
  }

  Future<void> deleteTab(int tabId) async {
    final database = await Repo.instance.db;

    await database.transaction((txn) async {
      await txn.delete('Notes', where: 'tabId = ?', whereArgs: [tabId]);
      await txn.delete('Tabs', where: 'id = ?', whereArgs: [tabId]);
    });
  }

  Future<List<Map<String, dynamic>>> getAllTabs() async {
    final database = await Repo.instance.db;

    return database.rawQuery('''
      SELECT Tabs.name AS tabName, Tunings.name AS tuningName, Tabs.id
      FROM Tabs
      JOIN Tunings ON Tabs.tuningId = Tunings.id
    ''');
  }

  Future<Tab> readTab(int tabId) async {
    final database = await Repo.instance.db;

    final tabRows = await database.query(
      'Tabs',
      where: 'id = ?',
      whereArgs: [tabId],
      limit: 1,
    );
    if (tabRows.isEmpty) throw StateError('Tab $tabId not found');
    final tabRow = tabRows.first;

    final tuningRows = await database.query(
      'Tunings',
      where: 'id = ?',
      whereArgs: [tabRow['tuningId']],
      limit: 1,
    );
    if (tuningRows.isEmpty) {
      throw StateError('Tuning ${tabRow['tuningId']} not found');
    }
    final tuning = Tuning.fromMap(tuningRows.first);

    final noteRows = await database.query(
      'Notes',
      where: 'tabId = ?',
      whereArgs: [tabId],
      orderBy: 'gs, pos',
    );

    final noOfStrings = tabRow['noOfStrings'] as int;
    final notes = List.generate(noOfStrings, (_) => <Note>[]);

    for (final row in noteRows) {
      final gs = row['gs'] as int;
      if (gs < 0 || gs >= noOfStrings) continue; // ignore corrupt rows
      notes[gs].add(Note.fromMap(row));
    }

    return Tab.fromMap(tabRow, tuning, notes);
  }
}