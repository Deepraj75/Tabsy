import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabsy/data/models/tab/tab.dart';

const String userTabBox = "Tab box";

class RepoService
{
  static final userBox = Hive.box<Tab>(userTabBox);

  static Future<void> saveTab(Tab tab) async
  {
    await userBox.put(tab.id,tab);
  }

  static Tab? readTab(String id)
  {
    return userBox.get(id);
  }

  static List<Tab> getTabs()
  {
    return userBox.values.toList();
  }

  static Future<void> deleteTab(Tab tab)
  {
    return userBox.delete(tab.id);
  }
}