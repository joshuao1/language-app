import 'package:flutter/material.dart';
import 'package:language_app/data/history_dao.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/character_train_page.dart';
import 'package:language_app/widget/home_page.dart';
import 'package:provider/provider.dart';

import 'package:language_app/data/app_database.dart';
import 'package:language_app/data/character_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase.instance.database;
  final characterDao = CharacterDao(database);
  final historyDao = HistoryDao(database);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CharacterNotifier(characterDao)..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryNotifier(historyDao)..load(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Trainer',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      routes: {'/': (context) => HomePage()},
      initialRoute: '/',
      // home: HomePage(),
      // CharacterList(),
    );
  }
}
