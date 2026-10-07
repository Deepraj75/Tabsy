import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/repo_service.dart';

class TabListVm extends ChangeNotifier
{
  List<Map<String,dynamic>> _tabs = [];

  List<Map<String,dynamic>> get tabs => List.unmodifiable(_tabs);

  void loadTabs() async
  {
    _tabs = await RepoService.instance.getAllTabs();
    notifyListeners();
  }

  TabListVm()
  {
    loadTabs();
  }

  Future<void> deleteTab(int id) async
  {
    await RepoService.instance.deleteTab(id);
    loadTabs();
  }
}