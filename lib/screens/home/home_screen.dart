import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:provider/provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/responsive.dart';
import 'package:price/screens/analytics/analytics_screen.dart';
import 'package:price/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'components/side_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _loadCSV() async {
    final rawData = await rootBundle.loadString("data/data.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    setState(() {
      context.read<DataProvider>().readData(listData);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
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
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu()
              ),
            Expanded(
              flex: 7,
              child: context.watch<MenuProvider>().menu == 1
                  ? DashboardScreen()
                  : AnalyticsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
