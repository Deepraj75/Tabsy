import 'package:flutter/material.dart' hide Tab;
import 'package:tabsy/data/models/tab/tab.dart';
import 'package:tabsy/data/repository/repo.dart';

class ReadScreenVm extends ChangeNotifier
{
  String id;
  Tab? tab;

  void updateTab()
  {
    tab = Repo.readTab(id);
    notifyListeners();
  }

  ReadScreenVm(this.id)
  {
    updateTab();
  }
}