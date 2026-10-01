import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/models/tab.dart';
import 'package:tabsy/data/repo_service.dart';

class TabListVm extends ChangeNotifier
{
  List<List<String>> _tabs = [];

  List<Tab> get tabs => List.unmodifiable(_tabs);

  void loadTabs() async
  {
    _tabs = await RepoService.instance.getAllTabs();
    notifyListeners();
  }

  TabListVm()
  {
    loadTabs();
  }

  Future<void> deleteTab(Tab tab) async
  {
    await RepoService.instance.deleteTab(tab.id!);
    loadTabs();
  }
}