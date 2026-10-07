import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/models/tab.dart';
import 'package:tabsy/data/repo_service.dart';

class ReadScreenVm extends ChangeNotifier
{
  int id;
  Tab? tab;
  bool _initialized = false;

  bool get initialized => _initialized;

  void updateTab() async
  {
    tab = await RepoService.instance.readTab(id);
    _initialized = true;
    notifyListeners();
  }

  ReadScreenVm(this.id)
  {
    updateTab();
  }
}