import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabsy/ui/tab_list/tab_list_vm.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TabListVm>();

    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search by name of Tab"
        ),
      onChanged: (word) {vm.search(word);}
    );
  }
}
