import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/edit_tab/edit_screen_vm.dart';

class ToolBar {
  static List<Widget> buildToolBar(
    BuildContext context,
    GlobalKey<FormFieldState> nameKey,
    GlobalKey<FormState> formKey,
  ) {
    final vm = context.read<EditScreenVm>();

    return [
      IconButton(icon: const Icon(Icons.redo), onPressed: vm.redo),

      IconButton(icon: const Icon(Icons.undo), onPressed: vm.undo),

      IconButton(
        icon: const Icon(Icons.save),
        onPressed: () async {
          if (!(nameKey.currentState?.validate() ?? false) ||
              !(formKey.currentState?.validate() ?? false)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("Fill up the details")),
            );
            return;
          }

          if (vm.activeBeat != null && vm.activeString != null) {
            if (vm.validateFret() != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Fret number is invalid")),
              );
              return;
            }
          }

          await vm.save();

          if (!context.mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: const Text("Your Tab is saved")));
        },
      ),
    ];
  }
}
