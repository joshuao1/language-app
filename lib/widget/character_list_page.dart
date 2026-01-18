import 'package:flutter/material.dart';
import 'package:language_app/widget/styled_container.dart';
import 'package:provider/provider.dart';
import 'package:language_app/notifier/character_notifier.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var characterNotifier = context.watch<CharacterNotifier>();

    if (characterNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Character List')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: characterNotifier.characters.length,
          itemBuilder: (context, index) {
            final character = characterNotifier.characters[index];
            return StyledContainer(
              child: Column(
                children: [
                  Text(character.character, style: TextStyle(fontSize: 24)),
                  Text(character.translation),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
