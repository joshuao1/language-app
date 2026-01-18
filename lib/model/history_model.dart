import 'dart:ffi';

class History {
  int? id;
  final int characterFk;
  final DateTime date;
  final bool correct;

  History({
    this.id,
    required this.characterFk,
    required this.date,
    required this.correct,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'character_fk': characterFk,
      'date': date.millisecondsSinceEpoch,
      'correct': correct,
    };
  }

  static History fromMap(Map<String, Object?> map) {
    return History(
      characterFk: map['character_fk'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      correct: (map['correct'] as int == 1),
    );
  }
}
