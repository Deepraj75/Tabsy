import 'package:tabsy/data/models/tab/tab.dart';
import 'package:tabsy/data/services/repo_service.dart';

class Repo {
  static Future<void> saveTab(Tab tab) async
  {
    await RepoService.saveTab(tab);
  }

  static Tab? readTab(String id)
  {
    return RepoService.readTab(id);
  }

  static List<Tab> getTabs()
  {
    return RepoService.getTabs();
  }

  static Future<void> deleteTab(Tab tab)
  {
    return RepoService.deleteTab(tab);
  }
}
