import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  List<List<dynamic>> _metalData = [];
  List<List<dynamic>> get metalData => _metalData;

  List<List<dynamic>> _nometalData = [];
  List<List<dynamic>> get nometalData => _nometalData;

  List<List<dynamic>> _oilData = [];
  List<List<dynamic>> get oilData => _oilData;

  void readMetalData(List<List<dynamic>> data) {
    _metalData = data;
    notifyListeners();
  }

  void readNometalData(List<List<dynamic>> data) {
    _nometalData = data;
    notifyListeners();
  }

  void readOilData(List<List<dynamic>> data) {
    _oilData = data;
    notifyListeners();
  }
}
