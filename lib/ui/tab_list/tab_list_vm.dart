import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/repo_service.dart';
import 'package:tabsy/data/models/folder.dart';

class TabListVm extends ChangeNotifier {
  List<Map<String, dynamic>> _tabs = [];
  bool folderLoaded = false;
  List<Folder> folders = [];
  int? folderId;
  Set<int> selectedTabIds = {};
  bool isSearching = false;
  String searchWord = "";

  List<Map<String, dynamic>> get tabs => List.unmodifiable(_tabs);

  TabListVm() {
    loadTabs();
    loadFolders();
  }

  Future<void> loadTabs() async {
    _tabs = await RepoService.instance.getAllTabs();
    notifyListeners();
  }

  Future<void> deleteTabs() async {
    for (int id in selectedTabIds) {
      await RepoService.instance.deleteTab(id);
    }

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

  Future<void> deleteFolder(int id) async
  {
    RepoService.instance.deleteFolder(id);
    notifyListeners();
  }

  Future<void> moveTabs(int? fid) async {
    for (final id in selectedTabIds) {
      RepoService.instance.moveTab(id, fid);
    }
  }

  void toggleSelect(int tabId) {
    if (!selectedTabIds.add(tabId)) {
      selectedTabIds.remove(tabId);
    }

    notifyListeners();
  }

  void clearSelection() {
    selectedTabIds = {};
  }

  bool folderMatches(int? fid) {
    if (folderId == null) return true;

    return folderId == fid;
  }

  bool searchMatches(String name) {
    if (searchWord.isEmpty) {
      return true;
    }

    return name.toLowerCase().contains(searchWord.toLowerCase());
  }

  void activateSearch() {
    isSearching = true;
    notifyListeners();
  }

  void cancelSearch() {
    isSearching = false;
    searchWord = "";
    notifyListeners();
  }

  void search(String word) {
    searchWord = word;
    notifyListeners();
  }
}
