import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/view_models/tab_list_vm.dart';
import 'ui/screens/tab_list.dart';

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: "Tabsy",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark
          ),
        ),
      home: ChangeNotifierProvider(
        create: (_) => TabListVm(),
        child: const TabListScreen()
      )
    );
  }
}