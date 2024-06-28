import 'package:flutter/material.dart';

class SearchDateProvider with ChangeNotifier {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  void setStartDate(DateTime startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  void setEndDate(DateTime endDate) {
    _endDate = endDate;
    notifyListeners();
  }
}
