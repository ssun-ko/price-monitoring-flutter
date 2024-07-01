import 'package:flutter/material.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/responsive.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String getUpdateTime() {
    var dataProvider = context.watch<DataProvider>();
    var menuProvider = context.watch<MenuProvider>();

    switch (menuProvider.menu) {
      case 2:
        if (dataProvider.metalData.isNotEmpty) {
          return dataProvider.metalData.last.first.toString();
        }
        break;
      case 3:
        if (dataProvider.nometalData.isNotEmpty) {
          return dataProvider.nometalData.last.first.toString();
        }
        break;
      case 4:
        if (dataProvider.oilData.isNotEmpty) {
          return dataProvider.oilData.last.first.toString();
        }
        break;
      default:
        if (dataProvider.oilData.isNotEmpty) {
          return dataProvider.oilData.last.first.toString();
        }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<DrawerProvider>().openDrawer),
        Spacer(),
        Text(updateDateMessage + getUpdateTime())
      ],
    );
  }
}
