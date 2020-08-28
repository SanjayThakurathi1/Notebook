import 'package:flutter/cupertino.dart';

class Changes extends ChangeNotifier {
  bool mode = false;
  void darkmode(bool value) {
    mode = value;

    notifyListeners();
  }
}
