import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/responsive.dart';
import 'package:price/screens/analytics/metal_screen.dart';
import 'package:price/screens/analytics/nometal_screen.dart';
import 'package:price/screens/analytics/oil_screen.dart';
import 'package:price/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _loadMonthlyMetalCSV() async {
    final rawData = await rootBundle.loadString(metalFilePath);
    List<List<dynamic>> listData =
        const CsvToListConverter(eol: '\n').convert(rawData);

    setState(() {
      context.read<DataProvider>().readMetalData(listData);
    });
  }

  void _loadDailyNometalCSV() async {
    final rawData = await rootBundle.loadString(nometalFilePath);
    List<List<dynamic>> listData =
        const CsvToListConverter(eol: '\n').convert(rawData);

    setState(() {
      context.read<DataProvider>().readNometalData(listData);
    });
  }

  void _loadDailyOilCSV() async {
    final rawData = await rootBundle.loadString(oilFilePath);
    List<List<dynamic>> listData =
        const CsvToListConverter(eol: '\n').convert(rawData);

    setState(() {
      context.read<DataProvider>().readOilData(listData);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMonthlyMetalCSV();
    _loadDailyNometalCSV();
    _loadDailyOilCSV();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.read<DrawerProvider>().scaffoldKey,
        drawer: SideMenu(),
        body: SafeArea(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (Responsive.isDesktop(context))
            SizedBox(width: 250, child: SideMenu()),
          Expanded(child: _buildScreen(context.watch<MenuProvider>().menu))
        ])));
  }

  Widget _buildScreen(int menu) {
    switch (menu) {
      case 1:
        return DashboardScreen();
      case 2:
        return MetalScreen();
      case 3:
        return NometalScreen();
      default:
        return OilScreen();
    }
  }
}
