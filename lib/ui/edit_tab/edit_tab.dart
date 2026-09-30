import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'package:tabsy/data/models/tab/tab.dart';
import 'package:tabsy/ui/view_models/edit_screen_vm.dart';
import 'package:tabsy/ui/widgets/edit_tab/tab_forms.dart';
import 'package:tabsy/ui/widgets/edit_tab/toolbar.dart';
import 'package:tabsy/ui/widgets/edit_tab/fret_grid.dart';
import 'package:tabsy/ui/widgets/edit_tab/note_properties.dart';
import 'package:tabsy/ui/widgets/edit_tab/new_measure_button.dart';

class EditScreen extends StatelessWidget {
  final Tab? tab;

  const EditScreen({super.key, this.tab});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditScreenVm(tab: tab),
      child: _EditScreenBody(),
    );
  }
}

class _EditScreenBody extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.edit),
        title: TabName(nameKey: _nameKey),
        backgroundColor: Colors.red,
        actions: ToolBar.buildToolBar(context, _nameKey, _formKey),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: TabDetails(formKey: _formKey)),
          SliverToBoxAdapter(child: SizedBox(height: 20.0)),
          FretGrid(),
          SliverToBoxAdapter(
            child:NewMeasureButton(add:vm.addMeasure)
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              FloatingActionButton(
                heroTag: "duration",
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ChangeNotifierProvider.value(
                      value: context.read<EditScreenVm>(),
                      child: const DurationDialog(),
                    ),
                  );
                },
                child: Text(DurationDialog.
                getDurationIcon(vm.activeDuration)),
              ),
            ],
          ),
          FloatingActionButton(
            heroTag: "effect",
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<EditScreenVm>(),
                  child: const EffectDialog(),
                ),
              );
            },
            child: Text(EffectDialog.getEffectIcon(vm.activeEffect)),
          ),
        ],
      ),
    );
  }
}
