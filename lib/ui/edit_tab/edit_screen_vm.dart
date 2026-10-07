import 'package:flutter/material.dart' hide Tab;
import 'package:collection/collection.dart';
import 'package:tabsy/data/models/note.dart';
import 'package:tabsy/data/models/tab.dart';
import 'package:tabsy/data/repo_service.dart';
import 'package:tabsy/data/models/tuning.dart';
import 'package:tabsy/logic/beats_divider.dart';

class EditScreenVm extends ChangeNotifier {
  Tab _currentTab = Tab();
  int? activeString;
  int? activeBeat;
  Effect activeEffect = Effect.none;
  Duration activeDuration = Duration.quarter;
  List<Tuning> tunings = [];
  final List<Tab> _undoStack = [];
  final List<Tab> _redoStack = [];
  bool _initialized = false;

  bool get initialized => _initialized;

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  EditScreenVm({Tab? tab}) {
    focusNode.addListener(_onFocusChanged);

    if (tab != null) {
      _currentTab = tab;
      _initialized = true;
      loadTunings();
      notifyListeners();
    } else {
      _initializeNewTab();
    }
  }

  Future<void> _initializeNewTab() async {
    try {
      tunings = await RepoService.instance.getAllTunings();

      final standard =
          tunings.firstWhereOrNull((t) => t.name == 'E Standard') ??
          (tunings.isNotEmpty ? tunings.first : null);

      _currentTab = standard != null ? Tab(tuning: standard) : Tab();
    } catch (e, st) {
      debugPrint('Failed to init new tab: $e\n$st');
      _currentTab = Tab();
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> loadTunings() async {
    tunings = await RepoService.instance.getAllTunings();
    notifyListeners();
  }

  void _onFocusChanged() {
    if (!focusNode.hasFocus) {
      if (validateFret() != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });
      }
    }
  }

  Tab get currentTab => _currentTab;

  Future<void> save() async {
    await RepoService.instance.saveTab(_currentTab);
  }

  void _commit(Tab newTab) {
    _undoStack.add(_currentTab);
    _redoStack.clear();

    _currentTab = newTab;
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isEmpty) {
      return;
    }

    _redoStack.add(_currentTab);
    _currentTab = _undoStack.removeLast();
    deselectActive();

    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) {
      return;
    }

    _undoStack.add(_currentTab);
    _currentTab = _redoStack.removeLast();
    deselectActive();

    notifyListeners();
  }

  void deselectActive() {
    activeBeat = null;
    activeString = null;

    notifyListeners();
  }

  void setActive(int c, int r, String fret) {
    if (validateFret() != null) {
      return;
    }

    TabWithBeats twb = BeatsDivider.getTabWithBeats(_currentTab);

    while (twb.beats[r][c].isStart == false) {
      --c;
      fret = twb.beats[r][c].note!.fret.toString();
    }

    activeBeat = c;
    activeString = r;

    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (fret == '-') {
        controller.text = "";
      } else {
        controller.text = fret;
      }
      focusNode.requestFocus();
    });
  }

  void changeTuning(Tuning tuning) {
    if (tuning != _currentTab.tuning) {
      _commit(_currentTab.copyWith(tuning: tuning));
    }
  }

  void changeNumerator(int upper) {
    if (upper != _currentTab.upperFraction) {
      _commit(_currentTab.copyWith(upperFraction: upper));
    }
  }

  void changeDenominator(int lower) {
    if (lower != _currentTab.lowerFraction) {
      _commit(_currentTab.copyWith(lowerFraction: lower));
    }
  }

  void changeName(String newName) {
    String validName = newName.trim();
    if (validName == _currentTab.name) {
      return;
    }

    _commit(_currentTab.copyWith(name: validName));
  }

  void changeBpm(int newBpm) {
    if (newBpm != _currentTab.bpm) {
      _commit(_currentTab.copyWith(bpm: newBpm));
    }
  }

  void changeArtist(String newArtist) {
    String validArtist = newArtist.trim();
    if (validArtist == _currentTab.artist) {
      return;
    }

    _commit(_currentTab.copyWith(artist: validArtist));
  }

  void changeTran(String newTran) {
    String validTran = newTran.trim();
    if (validTran == _currentTab.transcribed) {
      return;
    }

    _commit(_currentTab.copyWith(transcribed: validTran));
  }

  String? validateFret() {
    final text = controller.text;

    if (text.isEmpty) return null;

    final fret = int.tryParse(text);

    if (fret == null) {
      return "Please enter an Integer";
    }

    if (fret < 0 || fret > 24) {
      return "Enter a valid Fret number";
    }

    return null;
  }

  void changeFret() {
    if (activeString == null || activeBeat == null) {
      return;
    }

    if (validateFret() != null) {
      return;
    }

    TabWithBeats twb = BeatsDivider.getTabWithBeats(_currentTab);

    int noteIndex = twb.beats[activeString!][activeBeat!].index;
    Note? note = twb.beats[activeString!][activeBeat!].note;

    final newNotes = _currentTab.notes
        .map((tabs) => List<Note>.from(tabs))
        .toList();

    int newFret;

    if (controller.text != '') {
      newFret = int.parse(controller.text);
    } else {
      newFret = -1;
    }

    if (activeBeat! + 1 > twb.totals[activeString!]) {
      for (int i = twb.totals[activeString!]; i < activeBeat!; ++i) {
        newNotes[activeString!].add(Note());
      }
    }

    if (note == null) {
      newNotes[activeString!].add(
        Note(
          fret: newFret,
          noteEffect: activeEffect,
          noteDuration: activeDuration,
        ),
      );
    } else {
      newNotes[activeString!][noteIndex] = note.copyWith(
        fret: newFret,
        effect: activeEffect,
        duration: activeDuration,
      );
    }

    int newTotalBeats = activeBeat! + activeDuration.units ~/ twb.oneBeat;

    for (int i = 0; i < _currentTab.notes.length; ++i) {
      if (i == activeString) continue;

      if (newTotalBeats > twb.totals[i]) {
        int remaining = newTotalBeats - twb.totals[i];

        for (int j = 0; j < remaining; j++) {
          newNotes[i].add(Note());
        }
      }
    }

    _commit(_currentTab.copyWith(notes: newNotes));
  }

  void changeEffect(Effect effect) {
    activeEffect = effect;

    if (activeBeat != null && activeString != null) {
      TabWithBeats twb = BeatsDivider.getTabWithBeats(_currentTab);

      if (twb.beats[activeString!][activeBeat!].note != null) {
        changeFret();
      }
    } else {
      notifyListeners();
    }
  }

  void changeDuration(Duration d) {
    activeDuration = d;

    if (activeBeat != null && activeString != null) {
      TabWithBeats twb = BeatsDivider.getTabWithBeats(_currentTab);

      if (twb.beats[activeString!][activeBeat!].note != null) {
        changeFret();
      }
    } else {
      notifyListeners();
    }
  }

  void addMeasure() {
    TabWithBeats twb = BeatsDivider.getTabWithBeats(_currentTab);

    int currMax = twb.totals.max;
    int measure = twb.tab.upperFraction;

    int currentMeasures = (currMax / measure).ceil();
    int newTotalBeats = currentMeasures * measure;

    final newNotes = _currentTab.notes
        .map((tabs) => List<Note>.from(tabs))
        .toList();

    for (int i = 0; i < newNotes.length; ++i) {
      int extra = measure;
      int remaining = newTotalBeats - twb.totals[i] + extra;

      while (remaining-- > 0) {
        newNotes[i].add(Note(fret: -1));
      }
    }

    _commit(twb.tab.copyWith(notes: newNotes));
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
