import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'package:tabsy/data/models/note/note.dart';
import 'package:tabsy/ui/view_models/edit_screen_vm.dart';
import 'package:tabsy/logic/beats_divider.dart';
import 'package:tabsy/data/models/beat.dart';

class TabBlock extends StatelessWidget {
  final int index;
  final int onBlock;
  final TabWithBeats twb;
  final double cw;
  final double ch;

  const TabBlock({
    required this.index,
    required this.onBlock,
    required this.twb,
    required this.cw,
    required this.ch,
    super.key,
  });

  int getGlobalBeat(int beat) {
    return index * (onBlock - 1) + beat - 1;
  }
  //return actual beat

  String getText(int beat, int gs) {
    Beat currBeat = twb.beats[gs][beat];

    if (!currBeat.isStart) {
      return "<-";
    }

    if (currBeat.note != null) {
      if (currBeat.note!.fret == -1) {
        return '-';
      } else {
        return currBeat.note!.fret.toString();
      }
    } else {
      return "";
    }
  }

  Widget getContent(int beat, int gs, int? ac, int? ar) {
    if (beat == 0) {
      return Text(
        twb.tab.tuning.strings[gs],
        style: TextStyle(color: Colors.white),
      );
    }

    ar = ar ?? -1;
    ac = ac ?? -1;

    int globalBeat = getGlobalBeat(beat);
    String text = getText(globalBeat, gs);

    if (globalBeat == ac && gs == ar) {
      return CellForm();
    } else {
      String endMeasure = "";
      String endChar = "  |";
      int measure = twb.tab.upperFraction;

      if (globalBeat % measure == measure - 1) {
        if (twb.beats[gs][globalBeat].note != null &&
            twb.beats[gs][globalBeat].note!.fret == -1) {
          return Text(endChar);
        } else {
          endMeasure = endChar;
        }
      }

      String effect = "";

      if (twb.beats[gs][globalBeat].note != null &&
          twb.beats[gs][globalBeat].note!.fret != -1 &&
          twb.beats[gs][globalBeat].isStart == true) {
        switch (twb.beats[gs][globalBeat].note!.noteEffect) {
          case Effect.hammerOn:
            effect = "h";
            break;
          case Effect.pullOff:
            effect = "p";
            break;
          case Effect.vibrato:
            effect = "~";
            break;
          default:
            effect = "";
        }
      }
      return Text(
        text + effect + endMeasure,
        style: TextStyle(color: Colors.black),
      );
    }
  }

  String getPMtext(int beat) {
    if (beat == 0) {
      return "";
    }

    int globalBeat = getGlobalBeat(beat);

    if (isPMuted(globalBeat)) {
      if (isPMuted(globalBeat - 1)) {
        return ".........";
      } else {
        return "P.M...";
      }
    }

    return "";
  }

  bool isPMuted(int beat) {
    if (beat < 0 ) {
      return false;
    }

    bool muted = false;

    for (int i = 0; i < twb.beats.length; ++i) {
      if (beat < twb.beats[i].length &&
        twb.beats[i][beat].note != null) {
        if (twb.beats[i][beat].note!.noteEffect == Effect.palmMuted
        && twb.beats[i][beat].note!.fret != -1) {
          muted = true;
        }
      }
    }

    return muted;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return Column(
      children: [
        ...List.generate(
          twb.beats.length,
          (guitarString) => Row(
            children: List.generate(
              onBlock,
              (beat) => getGlobalBeat(beat) >= twb.beats[0].length
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        if (vm.validateFret() != null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Enter a valid Fret Number",
                                ),
                              ),
                            );

                          return;
                        }

                        int globalBeat = getGlobalBeat(beat);
                        vm.setActive(
                          globalBeat,
                          guitarString,
                          getText(globalBeat, guitarString),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 3.0,
                          left: 3.0,
                          right: 3.0,
                        ),
                        child: Container(
                          color: beat == 0 ? Colors.black : Colors.white,
                          height: ch,
                          width: cw,
                          child: Center(
                            child: getContent(
                              beat,
                              guitarString,
                              vm.activeBeat,
                              vm.activeString,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Padding(
          padding:EdgeInsets.only(
            left:20.0
          ),
          child:SizedBox(
          height: 30,
          child: Row(
            children: List.generate(
              onBlock,
              (beat) => SizedBox(width: cw, child: Text(getPMtext(beat))),
            ),)
          ),
        ),
      ],
    );
  }
}

class CellForm extends StatefulWidget {
  const CellForm({super.key});

  @override
  State<CellForm> createState() => CellFormState();
}

class CellFormState extends State<CellForm> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.black),
      controller: vm.controller,
      focusNode: vm.focusNode,
      validator: (_) => vm.validateFret(),
      onTapOutside: (_) {
        if (vm.validateFret() != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: const Text("Enter a valid Fret Number")),
            );

          return;
        }
        vm.changeFret();
      },
      onFieldSubmitted: (_) {
        if (vm.validateFret() != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: const Text("Enter a valid Fret Number")),
            );

          return;
        }
        vm.changeFret();
        vm.deselectActive();
      },
    );
  }
}

class FretGrid extends StatelessWidget {
  final double cellWidth = 50;
  final double cellHeight = 25;

  const FretGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();
    final TabWithBeats grid = BeatsDivider.getTabWithBeats(vm.currentTab);

    double screenWidth = MediaQuery.of(context).size.width;

    int onBlock = screenWidth ~/ cellWidth;
    int noOfBlocks = (grid.beats[0].length / (onBlock - 1)).ceil();

    return SliverList.builder(
      itemCount: noOfBlocks,
      itemBuilder: (BuildContext context, int index) {
        return TabBlock(
          index: index,
          onBlock: onBlock,
          twb: grid,
          cw: cellWidth,
          ch: cellHeight,
        );
      },
    );
  }
}
