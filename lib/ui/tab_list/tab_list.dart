import 'package:flutter/material.dart' hide Tab;
import 'package:provider/provider.dart';
import 'tab_list_vm.dart';
import 'widgets/add_folder_button.dart';
import 'widgets/delete_folder_button.dart';
import 'widgets/move_folder.dart';
import 'widgets/search_tab.dart';
import 'package:tabsy/ui/edit_tab/edit_tab.dart';
import 'package:tabsy/ui/read_tab/read_tab.dart';

class TabListScreen extends StatelessWidget {
  const TabListScreen({super.key});

  bool isSelected(TabListVm vm, int index) {
    if (index == 0) return vm.folderId == null;

    return vm.folderId == vm.folders[index - 1].id;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TabListVm>();
    final theme = Theme.of(context);

    List<Map<String, Object?>> filteredTabs = [];

    for (final tab in vm.tabs) {
      if (vm.folderMatches(tab["folderId"]) &&
          vm.searchMatches(tab["tabName"])) {
        filteredTabs.add(tab);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: !vm.isSearching ? Text("Your Tabs") : SearchTab(),
        backgroundColor: Colors.green,
        actions: [
          !vm.isSearching
              ? IconButton(
                  onPressed: vm.activateSearch,
                  icon: const Icon(Icons.search),
                )
              : IconButton(
                  onPressed: vm.cancelSearch,
                  icon: const Icon(Icons.cancel),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                vm.clearSelection();
                return EditScreen(folderId: vm.folderId);
              },
            ),
          );

          vm.loadTabs();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
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
                              style: TextButton.styleFrom(
                                foregroundColor: isSelected(vm, index)
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                                backgroundColor: isSelected(vm, index)
                                    ? theme.colorScheme.primary
                                    : Colors.transparent,
                              ),
                              onPressed: () {
                                vm.changeFolder(
                                  index == 0 ? null : vm.folders[index - 1].id,
                                );
                                vm.clearSelection();
                              },
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
                DeleteFolderButton(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTabs.length,
              itemBuilder: (context, index) {
                final tab = filteredTabs[index];

                return ListTile(
                  title: Text(tab['tabName'] as String),
                  subtitle: Text(tab['tuningName'] as String),
                  selected: vm.selectedTabIds.contains(tab['id'] as int),
                  selectedTileColor: Colors.white,
                  selectedColor: Colors.black,
                  onTap: () async {
                    vm.clearSelection();
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ReadScreen(id: tab['id'] as int),
                      ),
                    );
                    vm.loadTabs();
                  },
                  trailing: IconButton(
                    onPressed: () {
                      vm.toggleSelect(tab['id'] as int);
                    },
                    icon: Icon(
                      vm.selectedTabIds.contains(tab['id'] as int)
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: vm.selectedTabIds.isNotEmpty
          ? BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: vm.deleteTabs,
                  ),
                  IconButton(
                    icon: Icon(Icons.drive_file_move),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ChangeNotifierProvider.value(
                          value: context.watch<TabListVm>(),
                          child: const MoveFolder(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: () {
                      List<int> ids = [];
                      for (final tab in filteredTabs) {
                        ids.add(tab["id"] as int);
                      }
                      vm.selectAll(ids);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: vm.clearSelection,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
