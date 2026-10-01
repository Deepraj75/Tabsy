import 'package:tabsy/data/models/note.dart';
import 'package:tabsy/data/models/tab.dart';
import 'package:tabsy/data/models/beat.dart';
import 'package:collection/collection.dart';

class TabWithBeats {
  final Tab tab;
  final List<List<Beat>> beats;
  final List<int> totals;
  final int oneBeat;

  TabWithBeats({required this.tab, required this.beats,
  required this.totals, required this.oneBeat});
}

class BeatsDivider {
  static TabWithBeats getTabWithBeats(Tab tab) {
    List<List<Beat>> beats = List.generate(tab.notes.length, (_) => <Beat>[]);

    int upper = tab.upperFraction;
    int lower = tab.lowerFraction;
    int oneBeat = 240 ~/ lower;
    //only powers of 2 are allowed in lower
    int measure = upper * oneBeat;

    bool blank = true;
    List<int> totals = [];

    for (int i = 0; i < tab.notes.length; ++i) {
      List<Note> tabs = tab.notes[i];
      int total = 0;

      for (int j = 0; j < tabs.length; ++j) {
        Note note = tabs[j];
        int noOfBeats = note.noteDuration.units ~/ oneBeat;
        /*the duration are chosen so
        noOfBeats are always integer*/

        total += note.noteDuration.units;
        blank = false;

        beats[i].add(Beat(note: note,
        index:j , isStart: true));
        --noOfBeats;

        while (noOfBeats-- > 0) {
          beats[i].add(Beat(note: note,
          index:j, isStart: false));
        }
      }

      totals.add(total ~/ oneBeat);
    }

    int maxTotal = totals.max;
    int noOfMeasures = (maxTotal / upper).ceil();
    int totalBeats = noOfMeasures * upper;
    /* values are chosen such that this is
    always an integet*/

    for (int i = 0; i < tab.notes.length; ++i)
    {
      int remainingBeats = totalBeats - totals[i];

      while (remainingBeats-- > 0)
      {
        beats[i].add(Beat());
      }
      // make the number of beats equal for
      // all strings for better visual
    }

    if (blank)
    {
      for (var l in beats)
      {
        int blankbeats = measure ~/ oneBeat;

        while(blankbeats-- > 0)
        {
          l.add(Beat());
        }
      }
      //if tab is empty, fill a measure of beats
    }

    final finalBeats = List<List<Beat>>.unmodifiable(
      beats.map(List<Beat>.unmodifiable),
    );

    return TabWithBeats(tab: tab, beats: finalBeats,
    totals: totals, oneBeat: oneBeat);
  }
}
