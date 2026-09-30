import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/view_models/edit_screen_vm.dart';
import 'package:tabsy/data/models/tuning/tuning.dart';

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
    _nameController.text = context.read<EditScreenVm>().currentTab.name;

    _nameFN = FocusNode();

    _nameFN.addListener(() {
      if (!_nameFN.hasFocus) {
        saveName();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _nameFN.dispose();
  }

  void saveName() {
    if (widget.nameKey.currentState!.validate()) {
      final vm = context.read<EditScreenVm>();
      vm.changeName(_nameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    if (_nameController.text != vm.currentTab.name) {
      _nameController.text = vm.currentTab.name;
    }

    return TextFormField(
      key: widget.nameKey,
      controller: _nameController,
      focusNode: _nameFN,
      decoration: InputDecoration(
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

  const TabDetails({super.key, required this.formKey});

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

  @override
  void initState() {
    super.initState();

    _artistController.text = context.read<EditScreenVm>().currentTab.artist;
    _artistFN = FocusNode();
    _artistFN.addListener(() {
      if (!_artistFN.hasFocus) {
        saveArtist();
      }
    });

    _tranController.text = context.read<EditScreenVm>().currentTab.transcribed;
    _tranFN = FocusNode();
    _tranFN.addListener(() {
      if (!_tranFN.hasFocus) {
        saveTran();
      }
    });

    _bpmController.text = context
        .read<EditScreenVm>()
        .currentTab
        .bpm
        .toString();
    _bpmFN = FocusNode();
    _bpmFN.addListener(() {
      if (!_tranFN.hasFocus) {
        saveBpm();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _artistController.dispose();
    _artistFN.dispose();

    _tranController.dispose();
    _tranFN.dispose();

    _bpmController.dispose();
    _bpmFN.dispose();
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
    if (_bpmKey.currentState!.validate()) {
      int num = int.parse(_bpmController.text.trim());
      final vm = context.read<EditScreenVm>();
      vm.changeBpm(num);
    }
  }

  void saveArtist() {
    if (_artistKey.currentState!.validate()) {
      final vm = context.read<EditScreenVm>();
      vm.changeArtist(_artistController.text);
    }
  }

  void saveTran() {
    if (_tranKey.currentState!.validate()) {
      final vm = context.read<EditScreenVm>();
      vm.changeTran(_tranController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditScreenVm>();

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          //tuning
          Row(
            children: [
              SizedBox(width: widget.pad),
              const Text("Tuning: "),
              Expanded(
                child: DropdownButtonFormField(
                  initialValue: vm.currentTab.tuning.name == "E Standard"
                      ? Tuning.eStandard
                      : Tuning.dropD,
                  items: [Tuning.eStandard, Tuning.dropD]
                      .map(
                        (tuning) => DropdownMenuItem(
                          value: tuning,
                          child: Text(tuning.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    saveTuning(value!);
                  },
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),
          //time signature
          Row(
            children: [
              SizedBox(width: 20),
              const Text("Time Signature: "),
              SizedBox(
                width: widget.pad * 2,
                child: DropdownButtonFormField(
                  initialValue: vm.currentTab.upperFraction,
                  items: [3, 4, 5]
                      .map(
                        (upper) => DropdownMenuItem(
                          value: upper,
                          child: Text('$upper'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    saveNumerator(value!);
                  },
                ),
              ),
              const Text("/"),
              SizedBox(
                width: widget.pad * 2,
                child: DropdownButtonFormField(
                  initialValue: vm.currentTab.lowerFraction,
                  items: [2, 4, 8]
                      .map(
                        (lower) => DropdownMenuItem(
                          value: lower,
                          child: Text('$lower'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    saveDenominator(value!);
                  },
                ),
              ),
            ],
          ),
          //BPM
          Row(
            children: [
              SizedBox(width: widget.pad),
              Text("BPM: "),
              SizedBox(
                width: widget.pad * 7,
                child: TextFormField(
                  key: _bpmKey,
                  focusNode: _bpmFN,
                  controller: _bpmController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "BPM can't be empty";
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
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
          //Artist
          Row(
            children: [
              SizedBox(width: widget.pad),
              Text("Artist: "),
              Expanded(
                child: TextFormField(
                  key: _artistKey,
                  focusNode: _artistFN,
                  controller: _artistController,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Artist's name can't be empty";
                    } else {
                      return null;
                    }
                  },
                  onTapOutside: (_) => saveArtist(),
                  onFieldSubmitted: (_) => saveArtist(),
                ),
              ),
              SizedBox(width: widget.pad),
            ],
          ),
          //Trancriber
          Row(
            children: [
              SizedBox(width: widget.pad),
              Text("Transcribed by: "),
              Expanded(
                child: TextFormField(
                  key: _tranKey,
                  focusNode: _tranFN,
                  controller: _tranController,
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Transcriber's name can't be empty";
                    } else {
                      return null;
                    }
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
