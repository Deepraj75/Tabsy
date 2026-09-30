import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/models/tab/tab.dart';
import 'package:tabsy/data/repository/repo.dart';

class TabListVm extends ChangeNotifier
{
  List<Tab> _tabs = [];

  List<Tab> get tabs => List.unmodifiable(_tabs);

  void loadTabs()
  {
    _tabs = Repo.getTabs();
    notifyListeners();
  }

  TabListVm()
  {
    loadTabs();
  }

  Future<void> deleteTab(Tab tab) async
  {
    await Repo.deleteTab(tab);
    loadTabs();
  }
}