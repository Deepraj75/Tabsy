import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'tab_list_vm.dart';
import 'widgets/delete_dialog.dart';
import 'widgets/add_folder_button.dart';
import 'package:tabsy/ui/edit_tab/edit_tab.dart';
import 'package:tabsy/ui/read_tab/read_tab.dart';

class TabListScreen extends StatelessWidget {
  const TabListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TabListVm>();

    List<Map<String,Object?>> filteredTabs = [];

    for (final tab in vm.tabs)
    {
      if (vm.folderId == null)
      {
        filteredTabs.add(tab);
      }
      else
      {
        if (tab['folderId'] == vm.folderId)
        {
          filteredTabs.add(tab);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Your Tabs"), backgroundColor: Colors.green),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => EditScreen(folderId:vm.folderId)
            ),
          );

          vm.loadTabs();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56.0,
            child: Row(
              children: [
                Expanded(
                  child: vm.folderLoaded
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.folders.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                              onPressed: () => vm.changeFolder(
                                index == 0 ? null : vm.folders[index - 1].id,
                              ),
                              child: Center(
                                child: Text(
                                  index == 0
                                      ? 'All'
                                      : vm.folders[index - 1].name,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 1.0);
                          },
                        )
                      : CircularProgressIndicator(),
                ),
                AddFolderButton(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTabs.length,
              itemBuilder: (context, index) {
                final tab = filteredTabs[index];

                return ListTile(
                  title: Text(tab['tabName'] as String),
                  subtitle: Text(tab['tuningName'] as String),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ReadScreen(id: tab['id'] as int),
                      ),
                    );
                    vm.loadTabs();
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      final shouldDelete = await DeleteDialog.buildDD(
                        context,
                        tab['tabName'] as String,
                      );

                      if (shouldDelete!) {
                        vm.deleteTab(tab['id'] as int);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
