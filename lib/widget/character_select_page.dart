import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/notifier/character_notifier.dart';
import 'package:language_app/widget/character_train_page.dart';
import 'package:provider/provider.dart';

class CharacterSelectPage extends StatefulWidget {
  const CharacterSelectPage({super.key});

  @override
  State<CharacterSelectPage> createState() => _CharacterSelectPageState();
}

class _CharacterSelectPageState extends State<CharacterSelectPage> {
  CharacterNotifier? characterNotifier;
  final Map<String, bool> characterGroups = {
    'a': false,
    'ka': false,
    'sa': false,
    'ta': false,
    'na': false,
    'ha': false,
    'ma': false,
    'ya': false,
    'ra': false,
    'wa': false,
    'ga': false,
    'za': false,
    'da': false,
    'ba': false,
    'pa': false,
    'kya': false,
    'sha': false,
    'cha': false,
    'nya': false,
    'hya': false,
    'mya': false,
    'rya': false,
    'gya': false,
    'ja': false,
    'bya': false,
    'pya': false,
  };

  List<String> get selectedGroups =>
      characterGroups.entries.where((e) => e.value).map((e) => e.key).toList();

  bool get allSelected =>
      characterGroups.values.every((isSelected) => isSelected);

  void toggleSelectAll() {
    setState(() {
      final newValue = !allSelected;
      characterGroups.updateAll((_, _) => newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    characterNotifier = context.watch<CharacterNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Characters'),
        actions: [
          TextButton(
            onPressed: toggleSelectAll,
            child: Text(
              allSelected ? 'Clear all' : 'Select all',
              // style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: characterGroups.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.key),
              value: entry.value,
              activeColor: Colors.blue,
              onChanged: (checked) {
                setState(() {
                  characterGroups[entry.key] = checked!;
                });
              },
            );
          }).toList(),
        ),

        // ListView.builder(
        //   itemCount: characterGroups.length,
        //   itemBuilder: (context, index) {
        //     final entry = characterGroups[index].entries;
        //     // var selectedChars = characterGroups
        //     //     .where((group) => group.values.first)
        //     //     .map((group) => group.keys.first)
        //     //     .toList();
        //     // print(selectedChars);

        //     return CheckboxListTile(
        //       title: Text(entry.first.key),
        //       activeColor: Colors.blue,
        //       value: entry.first.value,
        //       onChanged: (bool? newValue) {
        //         setState(() {
        //           characterGroups[index] = {entry.first.key: newValue!};
        //         });
        //       },
        //     );
        //   },
        // ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
          onPressed: selectedGroups.isEmpty
              ? null
              : () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CharacterTrainerPage(
                      characterList: characterNotifier!.characters
                          // Provide list of characters that have been selected in the groups check list
                          .where(
                            (char) =>
                                selectedGroups.contains(char.characterGroup),
                          )
                          .toList(),
                    ),
                  ),
                ),
          label: Text(
            selectedGroups.isEmpty ? "Select a group" : "Start Training",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
