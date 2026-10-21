import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/repo_service.dart';
import 'package:tabsy/data/models/folder.dart';

class TabListVm extends ChangeNotifier {
  List<Map<String, dynamic>> _tabs = [];
  bool folderLoaded = false;
  List<Folder> folders = [];
  int? folderId;

  List<Map<String, dynamic>> get tabs => List.unmodifiable(_tabs);

  TabListVm() {
    loadTabs();
    loadFolders();
  }

  Future<void> loadTabs() async {
    _tabs = await RepoService.instance.getAllTabs();
    notifyListeners();
  }

  Future<void> deleteTab(int id) async {
    await RepoService.instance.deleteTab(id);
    await loadTabs();
  }

  Future<void> loadFolders() async {
    folders = await RepoService.instance.getAllFolders();
    folderLoaded = true;
    notifyListeners();
  }

  Future<void> changeFolder(int? id) async {
    folderId = id;
    notifyListeners();
    await loadTabs();
  }

  Future<bool> createFolder(String name) async {
    final existingId = await RepoService.instance.getFolder(name);

    if (existingId != null) {
      return false;
    }

    final newId = await RepoService.instance.createFolder(name);

    await loadFolders();
    await changeFolder(newId);

    return true;
  }
}