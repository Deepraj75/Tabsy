import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/tab_list/tab_list_vm.dart';
import 'package:tabsy/data/models/folder.dart';

class MoveFolder extends StatelessWidget {
  const MoveFolder({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TabListVm>();

    List<Folder> foldersForMoving = [Folder(name:"None",)];
    
    for(Folder f in vm.folders)
    {
      foldersForMoving.add(f);
    }

    return AlertDialog(
      title: const Text("Choose a Folder to move to"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: foldersForMoving.map((f) {
          return ListTile(
            selected: f.id == vm.folderId,
            title: Text(f.name),
            onTap: () {
              vm.moveTabs(f.id);
              vm.loadTabs();
              vm.clearSelection();
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
