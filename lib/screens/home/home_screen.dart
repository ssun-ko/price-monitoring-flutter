import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price/providers/daily_nometal_data_provider.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/responsive.dart';
import 'package:price/screens/analytics/metal_screen.dart';
import 'package:price/screens/analytics/nometal_screen.dart';
import 'package:price/screens/analytics/oil_screen.dart';
import 'package:price/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/daily_oil_data_provider.dart';
import '../../providers/monthly_metal_data_provider.dart';
import 'components/side_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _loadMonthlyMetalCSV() async {
    final rawData = await rootBundle.loadString("data/monthly_metal_data.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    print(rawData);

    setState(() {
      context.read<MonthlyMetalDataProvider>().readData(listData);
    });
  }

  void _loadDailyNometalCSV() async {
    final rawData = await rootBundle.loadString("data/daily_nometal_data.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    setState(() {
      context.read<DailyNometalDataProvider>().readData(listData);
    });
  }

  void _loadDailyOilCSV() async {
    final rawData = await rootBundle.loadString("data/daily_oil_data.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    setState(() {
      context.read<DailyOilDataProvider>().readData(listData);
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
            Expanded(
                flex: 7,
                child: context.watch<MenuProvider>().menu == 1
                    ? DashboardScreen()
                    : context.watch<MenuProvider>().menu == 2
                        ? MetalScreen()
                        : context.watch<MenuProvider>().menu == 3
                            ? NometalScreen()
                            : OilScreen()),
          ],
        ),
      ),
    );
  }
}
