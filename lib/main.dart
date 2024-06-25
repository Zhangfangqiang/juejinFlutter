import 'paper/paper.dart';
import 'guess/guess_page.dart';
import 'counter/counter_page.dart';
import 'package:flutter/material.dart';
import 'navigation/app_navigation.dart';
import './storage/db_storage/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbStorage.instance.open();
  runApp(const MyApp());
}

/**
 * 无状态组件
 */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterDemo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const AppNavigation(),
    );
  }
}
