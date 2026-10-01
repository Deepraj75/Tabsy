import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'tab_list_vm.dart';
import 'widgets/delete_dialog.dart';
import 'package:tabsy/ui/edit_tab/edit_tab.dart';
import 'package:tabsy/ui/read_tab/read_tab.dart';

class TabListScreen extends StatelessWidget {
  const TabListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TabListVm>();

    return Scaffold(
      appBar: AppBar(title: Text("Your Tabs"), backgroundColor: Colors.green),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => EditScreen()),
          );

          vm.loadTabs();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: vm.tabs.length,
        itemBuilder: (context, index) {
          final tab = vm.tabs[index];

          return ListTile(
            title: Text(tab.name),
            subtitle: Text(tab.tuning!.name),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => ReadScreen(id: tab.id!)),
              );
              vm.loadTabs();
            },
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await DeleteDialog.buildDD(
                  context,
                  tab.name,
                );

                if (shouldDelete!) {
                  vm.deleteTab(tab);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
