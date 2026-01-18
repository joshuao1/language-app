import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/model/character_model.dart';
import 'package:language_app/model/character_session.dart';
import 'package:language_app/model/history_model.dart';
import 'package:language_app/notifier/history_notifier.dart';
import 'package:language_app/widget/results_page.dart';
import 'package:language_app/widget/styled_container.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class CharacterTrainerPage extends StatefulWidget {
  final List<Character> characterList;
  const CharacterTrainerPage({super.key, required this.characterList});

  @override
  State<CharacterTrainerPage> createState() => _CharacterTrainerPageState();
}

class _CharacterTrainerPageState extends State<CharacterTrainerPage> {
  // final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  int index = 0;
  Color boxColor = Colors.white;
  String answer = '';
  Set errors = {};
  final stopwatch = Stopwatch();
  final player = AudioPlayer();
  List<History> historyList = [];
  HistoryNotifier? historyNotifier;

  late FocusNode inputFocusNode;

  @override
  void initState() {
    super.initState();
    widget.characterList.shuffle();
    stopwatch.start();
    inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    inputFocusNode.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> saveHistory() async {
    for (var item in historyList) {
      historyNotifier!.addHistory(item);
    }
  }

  Future<void> checkAnswer() async {
    Character character = widget.characterList[index];
    if (character.translation == _controller.value.text) {
      await player.play(AssetSource(character.audio));
      setState(() {
        historyList.add(
          History(
            characterFk: character.id!,
            date: DateTime.now(),
            correct: true,
          ),
        );
        boxColor = Colors.green;
        index += 1;
        answer = '';
        if (index >= widget.characterList.length) {
          saveHistory();
          index = 0;
          stopwatch.stop();
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ResultsPage(
                sessionData: CharacterSession(
                  date: DateTime.now(),
                  content: widget.characterList,
                  duration: stopwatch.elapsed,
                  errors: errors.toList(),
                ),
              ),
            ),
          );
        }
      });
    } else {
      setState(() {
        historyList.add(
          History(
            characterFk: character.id!,
            date: DateTime.now(),
            correct: false,
          ),
        );
        boxColor = Colors.red;
        answer = character.translation;
        errors.add(character.id);
      });
    }
    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        boxColor = Colors.white;
      });
    });
    _controller.clear();
    inputFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    historyNotifier = context.watch<HistoryNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text("Character Trainer")),
      body: SafeArea(
        child: StyledContainer(
          color: boxColor,
          child: Column(
            spacing: 20,
            children: [
              Text(
                widget.characterList[index].character,
                style: TextStyle(fontSize: 60),
              ),
              CupertinoTextField(
                controller: _controller,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (String value) {
                  checkAnswer();
                  inputFocusNode.requestFocus();
                },
                autofocus: true,
                focusNode: inputFocusNode,
              ),
              if (answer.isNotEmpty) Text(answer),

              ElevatedButton.icon(
                onPressed: () => checkAnswer(),
                label: Text("Next"),
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
