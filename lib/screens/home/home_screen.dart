import 'package:price_monitoring/providers/drawer_provider.dart';
import 'package:provider/provider.dart';
import 'package:price_monitoring/providers/menu_provider.dart';
import 'package:price_monitoring/responsive.dart';
import 'package:price_monitoring/screens/analytics/analytics_screen.dart';
import 'package:price_monitoring/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'components/side_menu.dart';

class HomeScreen extends StatelessWidget {
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
                child: SideMenu(),
              ),
            Expanded(
              flex: 7,
              child: context.watch<MenuProvider>().menu == 1 ? DashboardScreen() : AnalyticsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
