import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier{
  int _menu = 1;
  int get menu => _menu;

  void changeMenu(int menu){
    _menu = menu;
    notifyListeners();
  }
}