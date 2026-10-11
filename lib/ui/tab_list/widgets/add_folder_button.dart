import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/tab_list/tab_list_vm.dart';

class AddFolderButton extends StatelessWidget {
  const AddFolderButton({super.key});

  Future<void> _onPressed(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<TabListVm>();

    final folderName = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _NewFolderDialog(),
    );

    if (folderName == null) return;

    final created = await vm.createFolder(folderName);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          created ? 'Created folder "$folderName"' : 'Folder already exists',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'New folder',
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.create_new_folder_outlined),
    );
  }
}

class _NewFolderDialog extends StatefulWidget {
  const _NewFolderDialog();

  @override
  State<_NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<_NewFolderDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Folder'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(hintText: 'Enter folder name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}