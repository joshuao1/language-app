import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_app/model/character_model.dart';

class CharacterTrainerNotifier extends ChangeNotifier {
  final List<Character> _characterList;
  final _player = AudioPlayer();
  final _stopwatch = Stopwatch()..start();
  final Set _errors = {};
  int _index = 0;
  Color _boxColor = Colors.white;
  Timer? _flashTimer;

  CharacterTrainerNotifier({required List<Character> characters})
    : _characterList = List.of(characters)..shuffle();

  // Getters
  Character get character =>
      _characterList[min(_index, _characterList.length - 1)];
  List<Character> get characterList => _characterList;
  Color get widgetColor => _boxColor;
  bool get isFinished => _index >= _characterList.length;
  Duration get duration => _stopwatch.elapsed;
  Set get errors => _errors;

  // next character
  void nextCharacter() {
    _index += 1;
    print('new _index $_index');
    notifyListeners();
  }

  void _flash(Color color) {
    _flashTimer?.cancel();
    _boxColor = color;
    notifyListeners();
    _flashTimer = Timer(Duration(milliseconds: 700), () {
      _boxColor = Colors.white;
      notifyListeners();
    });
  }

  // check answer
  void checkAnswer(String answer) {
    print("checking answer in notifier $answer");
    if (answer == character.translation) {
      print('correct answer');
      _player.play(AssetSource(character.audio));
      _flash(Colors.green);
      nextCharacter();
    } else {
      _flash(Colors.red);
      _errors.add(character.id!);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _flashTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }
}
