import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  List<List<dynamic>> _metalData = [];

  List<List<dynamic>> get metalData => _metalData;

  List<List<dynamic>> _noMetalData = [];

  List<List<dynamic>> get noMetalData => _noMetalData;

  List<List<dynamic>> _oilData = [];

  List<List<dynamic>> get oilData => _oilData;

  void readMetalData(List<List<dynamic>> data) {
    _metalData = data;
    notifyListeners();
  }

  void readNoMetalData(List<List<dynamic>> data) {
    _noMetalData = data;
    notifyListeners();
  }

  void readOilData(List<List<dynamic>> data) {
    _oilData = data;
    notifyListeners();
  }
}
