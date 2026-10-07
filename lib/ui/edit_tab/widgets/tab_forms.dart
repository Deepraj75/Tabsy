import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/edit_tab/edit_screen_vm.dart';
import 'package:tabsy/data/models/tuning.dart';

class TabName extends StatefulWidget {
  final GlobalKey<FormFieldState> nameKey;

  const TabName({super.key, required this.nameKey});

  @override
  State<TabName> createState() => TabNameState();
}

class TabNameState extends State<TabName> {
  final _nameController = TextEditingController();
  late final FocusNode _nameFN;

  @override
  void initState() {
    super.initState();

    _nameFN = FocusNode();

    _nameFN.addListener(() {
      if (!_nameFN.hasFocus) {
        saveName();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFN.dispose();
    super.dispose();
  }

  void saveName() {
    if (widget.nameKey.currentState?.validate() ?? false) {
      final vm = context.read<EditScreenVm>();
      vm.changeName(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    if (!vm.initialized) {
      return const SizedBox(
        height: 48,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_nameController.text != vm.currentTab.name) {
      _nameController.text = vm.currentTab.name;
    }

    return TextFormField(
      key: widget.nameKey,
      controller: _nameController,
      focusNode: _nameFN,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Enter a title",
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Title can't be empty";
        }

        return null;
      },
      onTapOutside: (_) => saveName(),
      onFieldSubmitted: (_) => saveName(),
    );
  }
}

class TabDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double pad = 20;

  const TabDetails({
    super.key,
    required this.formKey,
  });

  @override
  State<TabDetails> createState() => TabDetailsState();
}

class TabDetailsState extends State<TabDetails> {
  final _artistKey = GlobalKey<FormFieldState<String>>();
  final _artistController = TextEditingController();
  late final FocusNode _artistFN;

  final _tranKey = GlobalKey<FormFieldState<String>>();
  final _tranController = TextEditingController();
  late final FocusNode _tranFN;

  final _bpmKey = GlobalKey<FormFieldState<String>>();
  final _bpmController = TextEditingController();
  late final FocusNode _bpmFN;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();

    _artistFN = FocusNode();
    _tranFN = FocusNode();
    _bpmFN = FocusNode();

    _artistFN.addListener(() {
      if (!_artistFN.hasFocus) {
        saveArtist();
      }
    });

    _tranFN.addListener(() {
      if (!_tranFN.hasFocus) {
        saveTran();
      }
    });

    _bpmFN.addListener(() {
      if (!_bpmFN.hasFocus) {
        saveBpm();
      }
    });
  }

  void _initializeControllers(EditScreenVm vm) {
    if (_controllersInitialized || !vm.initialized) {
      return;
    }

    _artistController.text = vm.currentTab.artist;
    _tranController.text = vm.currentTab.transcribed;
    _bpmController.text = vm.currentTab.bpm.toString();

    _controllersInitialized = true;
  }

  @override
  void dispose() {
    _artistController.dispose();
    _artistFN.dispose();

    _tranController.dispose();
    _tranFN.dispose();

    _bpmController.dispose();
    _bpmFN.dispose();

    super.dispose();
  }

  void saveTuning(Tuning tuning) {
    final vm = context.read<EditScreenVm>();
    vm.changeTuning(tuning);
  }

  void saveNumerator(int upper) {
    final vm = context.read<EditScreenVm>();
    vm.changeNumerator(upper);
  }

  void saveDenominator(int lower) {
    final vm = context.read<EditScreenVm>();
    vm.changeDenominator(lower);
  }

  void saveBpm() {
    if (_bpmKey.currentState?.validate() ?? false) {
      final num = int.parse(_bpmController.text.trim());
      final vm = context.read<EditScreenVm>();
      vm.changeBpm(num);
    }
  }

  void saveArtist() {
    if (_artistKey.currentState?.validate() ?? false) {
      final vm = context.read<EditScreenVm>();
      vm.changeArtist(_artistController.text);
    }
  }

  void saveTran() {
    if (_tranKey.currentState?.validate() ?? false) {
      final vm = context.read<EditScreenVm>();
      vm.changeTran(_tranController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    if (!vm.initialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    _initializeControllers(vm);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Tuning
          Row(
            children: [
              SizedBox(width: widget.pad),
              const Text("Tuning: "),
              Expanded(
                child: DropdownButtonFormField<Tuning>(
                  initialValue: vm.currentTab.tuning,
                  items: vm.tunings
                      .map(
                        (tuning) => DropdownMenuItem<Tuning>(
                          value: tuning,
                          child: Text(tuning.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      saveTuning(value);
                    }
                  },
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),

          // Time signature
          Row(
            children: [
              const SizedBox(width: 20),
              const Text("Time Signature: "),
              SizedBox(
                width: widget.pad * 2,
                child: DropdownButtonFormField<int>(
                  initialValue: vm.currentTab.upperFraction,
                  items: [3, 4, 5]
                      .map(
                        (upper) => DropdownMenuItem<int>(
                          value: upper,
                          child: Text('$upper'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      saveNumerator(value);
                    }
                  },
                ),
              ),
              const Text("/"),
              SizedBox(
                width: widget.pad * 2,
                child: DropdownButtonFormField<int>(
                  initialValue: vm.currentTab.lowerFraction,
                  items: [2, 4, 8]
                      .map(
                        (lower) => DropdownMenuItem<int>(
                          value: lower,
                          child: Text('$lower'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      saveDenominator(value);
                    }
                  },
                ),
              ),
            ],
          ),

          // BPM
          Row(
            children: [
              SizedBox(width: widget.pad),
              const Text("BPM: "),
              SizedBox(
                width: widget.pad * 7,
                child: TextFormField(
                  key: _bpmKey,
                  focusNode: _bpmFN,
                  controller: _bpmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "BPM can't be empty";
                    }

                    if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return "Give a positive integer";
                    }

                    return null;
                  },
                  onTapOutside: (_) => saveBpm(),
                  onFieldSubmitted: (_) => saveBpm(),
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),

          // Artist
          Row(
            children: [
              SizedBox(width: widget.pad),
              const Text("Artist: "),
              Expanded(
                child: TextFormField(
                  key: _artistKey,
                  focusNode: _artistFN,
                  controller: _artistController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Artist's name can't be empty";
                    }

                    return null;
                  },
                  onTapOutside: (_) => saveArtist(),
                  onFieldSubmitted: (_) => saveArtist(),
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),

          // Transcriber
          Row(
            children: [
              SizedBox(width: widget.pad),
              const Text("Transcribed by: "),
              Expanded(
                child: TextFormField(
                  key: _tranKey,
                  focusNode: _tranFN,
                  controller: _tranController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Transcriber's name can't be empty";
                    }

                    return null;
                  },
                  onTapOutside: (_) => saveTran(),
                  onFieldSubmitted: (_) => saveTran(),
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),
        ],
      ),
    );
  }
}