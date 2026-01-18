import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/widget/character_list_page.dart';
import 'package:language_app/widget/character_train_page.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedGroups = [
      'za',
      'ya',
      'wa',
      // 'ta',
      // 'sha',
      // 'sa',
      // 'rya',
      // 'ra',
      // 'pya',
      // 'pa',
      // 'nya',
      // 'na',
      // 'mya',
      // 'ma',
      // 'kya',
      // 'ka',
      // 'ja',
      // 'hya',
      // 'ha',
      // 'gya',
      // 'ga',
      // 'da',
      // 'cha',
      // 'bya',
      // 'ba',
      // 'a',
    ];
    final characterNotifier = context.watch<CharacterNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => CharacterListPage()),
                ),
                child: Text("Character List"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CharacterTrainerPage(
                      characterList: characterNotifier.characters
                          .where(
                            (char) =>
                                selectedGroups.contains(char.characterGroup),
                          )
                          .toList(),
                    ),
                  ),
                ),
                child: Text("Character Trainer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
