import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'package:tabsy/logic/beats_divider.dart';
import 'read_screen_vm.dart';
import 'package:tabsy/data/models/beat.dart';
import 'package:tabsy/data/models/note.dart';
import 'package:tabsy/ui/edit_tab/edit_tab.dart';

class ReadScreen extends StatelessWidget {
  final int id;

  const ReadScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReadScreenVm(id),
      child: _ReadScreenBody(),
    );
  }
}

class _ReadScreenBody extends StatelessWidget {
  const _ReadScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReadScreenVm>();

    if (vm.initialized == false)
    {
      return Center(child:CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.tab!.name),
        backgroundColor: Colors.lightBlue,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: ReadTabDetails()),
          SliverToBoxAdapter(child: SizedBox(height: 20.0)),
          ReadFrets(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        child: Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => EditScreen(tab: vm.tab),
            ),
          );
          vm.updateTab();
        },
      ),
    );
  }
}

class ReadTabDetails extends StatelessWidget {
  final double pad = 20.0;
  final String space = "  ";
  const ReadTabDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReadScreenVm>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: pad),
        Text("$space Tuning: ${vm.tab!.tuning!.name}"),
        Row(
          children: [
            SizedBox(width: 60.0),
            ...List.generate(
              vm.tab!.tuning!.strings.length,
              (index) => Text(' ${vm.tab!.tuning!.strings[index]} '),
            ),
          ],
        ),
        SizedBox(height: pad),
        Text(
          "$space Signature: ${vm.tab!.upperFraction}/${vm.tab!.lowerFraction}",
        ),
        SizedBox(height: pad),
        Text("$space BPM: ${vm.tab!.bpm}"),
        SizedBox(height: pad),
        Text("$space Artist: ${vm.tab!.artist}"),
        SizedBox(height: pad),
        Text("$space Transcribed by: ${vm.tab!.transcribed}"),
        SizedBox(height: pad),
      ],
    );
  }
}

class ReadFrets extends StatelessWidget {
  final double cellWidth = 30;
  final double cellHeight = 25;

  const ReadFrets({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReadScreenVm>();
    final TabWithBeats grid = BeatsDivider.getTabWithBeats(vm.tab!);

    double screenWidth = MediaQuery.of(context).size.width;

    int onBlock = screenWidth ~/ cellWidth;
    int noOfBlocks = (grid.beats[0].length / onBlock).ceil();
    // all grid.beats[i] have same length

    return SliverList.builder(
      itemCount: noOfBlocks,
      itemBuilder: (BuildContext context, int index) {
        return FretBlock(
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

class FretBlock extends StatelessWidget {
  final int index;
  final int onBlock;
  final TabWithBeats twb;
  final double cw;
  final double ch;

  const FretBlock({
    required this.index,
    required this.onBlock,
    required this.twb,
    required this.cw,
    required this.ch,
    super.key,
  });

  int getGlobalBeat(int beat) {
    return index * (onBlock) + beat;
  }

  String getText(int beat, int gs) {
    //beat.note == null case not handled
    if (beat >= twb.beats[gs].length) {
      return "";
    }

    Beat currBeat = twb.beats[gs][beat];

    String endMeasure = "";
    String endChar = "  |";
    int measure = twb.tab.upperFraction;

    if (beat % measure == measure - 1) {
      if (twb.beats[gs][beat].note != null &&
          twb.beats[gs][beat].note!.fret == -1) {
        return endChar;
      } else {
        endMeasure = endChar;
      }
    }

    if (!currBeat.isStart)
    {
      return endMeasure;
    }

    if (currBeat.note != null && currBeat.note!.fret != -1) {
      String effect = "";

      switch (currBeat.note!.noteEffect) {
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

      return currBeat.note!.fret.toString() + effect + endMeasure;
    }

    return "";
  }

  String getPMtext(int beat) {
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
    if (beat < 0) {
      return false;
    }

    bool muted = false;

    for (int i = 0; i < twb.beats.length; ++i) {
      if (beat < twb.beats[i].length && twb.beats[i][beat].note != null) {
        if (twb.beats[i][beat].note!.noteEffect == Effect.palmMuted &&
            twb.beats[i][beat].note!.fret != -1) {
          muted = true;
        }
      }
    }

    return muted;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: List.generate(
            twb.beats.length,
            (_) => Divider(color: Colors.white, thickness: 1, height: ch),
          ),
        ),
        Column(
          children: [
            ...List.generate(
              twb.beats.length,
              (guitarString) => Row(
                children: List.generate(
                  onBlock,
                  (beat) => SizedBox(
                      height: ch,
                      width: cw,
                      child: Center(
                        child: ColoredBox(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Text(
                            getText(getGlobalBeat(beat), guitarString),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 30,
                child: Row(
                  children: List.generate(
                    onBlock,
                    (beat) => SizedBox(width: cw, child: Text(getPMtext(beat))),
                  
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
