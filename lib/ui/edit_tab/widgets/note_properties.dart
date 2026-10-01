import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/data/models/note.dart';
import 'package:tabsy/ui/edit_tab/edit_screen_vm.dart';

class EffectDialog extends StatelessWidget {
  const EffectDialog({super.key});

  static String getEffectIcon(Effect effect) {
    switch (effect) {
      case Effect.none:
        return "-";
      case Effect.hammerOn:
        return "h";
      case Effect.pullOff:
        return "p";
      case Effect.vibrato:
        return "~";
      case Effect.palmMuted:
        return "P.M";
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return AlertDialog(
      title: const Text("Select Effect"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Effect.values.map((effect) {
          return ListTile(
            selected: effect == vm.activeEffect,
            title: Text(effect.name),
            onTap: () {
              vm.changeEffect(effect);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

class DurationDialog extends StatelessWidget {
  const DurationDialog({super.key});

  static String getDurationIcon(
    Duration duration) {
    switch (duration) {
      case Duration.whole:
        return "1";
      case Duration.half:
        return "1/2";
      case Duration.quarter:
        return "1/4";
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return AlertDialog(
      title: const Text("Select Duration"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Duration.values.map((d) {
          return ListTile(
            selected: d == vm.activeDuration,
            title: Text("${d.name} Note"),
            onTap: () {
              vm.changeDuration(d);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
