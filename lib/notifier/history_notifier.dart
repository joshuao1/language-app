import 'package:flutter/foundation.dart';
import 'package:language_app/data/history_dao.dart';
import 'package:language_app/model/history_model.dart';

class HistoryNotifier extends ChangeNotifier {
  final HistoryDao dao;
  HistoryNotifier(this.dao);

  List<History> _histories = [];
  bool _isLoading = false;

  List<History> get histories => _histories;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _histories = await dao.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHistory(History history) async {
    await dao.insert(history);
    await load();
  }
}
