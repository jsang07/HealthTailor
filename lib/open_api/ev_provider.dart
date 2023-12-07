import 'package:flutter/material.dart';
import 'package:health_taylor/open_api/ev.dart';
import 'package:health_taylor/open_api/ev_repositiory.dart';

class EvProvider extends ChangeNotifier {
  EvRepository _evRepository = EvRepository();

  List<Ev> _evs = [];
  List<Ev> get evs => _evs;

  // 데이터 로드
  loadEvs() async {
    List<Ev>? listEvs = (await _evRepository.loadEvs()).cast<Ev>();

    if (listEvs != null) {
      _evs = listEvs;
    } else {
      _evs = [];
    }
    notifyListeners();
  }
}
