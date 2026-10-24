import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/tab_list/tab_list_vm.dart';
import 'package:tabsy/data/models/folder.dart';

class DeleteFolderButton extends StatelessWidget {
  const DeleteFolderButton({super.key});

  Future<void> _onPressed(BuildContext context) async {
    final vm = context.read<TabListVm>();            // grab before any await
    final messenger = ScaffoldMessenger.of(context);

    final folder = await showDialog<Folder>(         // use your folder type
      context: context,
      builder: (_) => _PickFolderDialog(folders: vm.folders),
    );
    
    if (folder == null) return;                      // cancelled

    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${folder.name}"?'),
        content: const Text('All the tabs in this folder will be moved to the root directory.If you do not wish for this to happen, move them to another folder'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await vm.deleteFolder(folder.id!);   
    await vm.loadFolders();
    await vm.loadTabs();
    vm.clearSelection();

    messenger.showSnackBar(
      SnackBar(content: Text('Deleted "${folder.name}"')),
    );
  }

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Delete folder',
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.delete),
      );
}

class _PickFolderDialog extends StatelessWidget {
  const _PickFolderDialog({required this.folders});
  final List<Folder> folders;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a folder to delete'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final f in folders)
              ListTile(
                title: Text(f.name),
                onTap: () => Navigator.pop(context, f),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ]
    );
  }
}