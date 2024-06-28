import 'package:flutter/material.dart';

class MonthlyMetalDataProvider extends ChangeNotifier {
  List<List<dynamic>> _data = [];
  List<List<dynamic>> get data => _data;

  void readData(List<List<dynamic>> data) {
    _data = data;
    notifyListeners();
  }
}
