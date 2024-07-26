import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/responsive.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 80,
                child: DrawerHeader(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("원자재 가격 모니터링 시스템")],
                ))),
            DrawerListTile(
              title: "종합 대시보드",
              icon: Icons.dashboard_rounded,
              isSelected:
                  context.watch<MenuProvider>().menu == 1 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(1);
                if (Responsive.isMobile(context))
                  context.read<DrawerProvider>().closeDrawer();
              },
            ),
            DrawerListTile(
              title: "철강 가격 정보",
              icon: Icons.analytics_rounded,
              isSelected:
                  context.watch<MenuProvider>().menu == 2 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(2);
                if (Responsive.isMobile(context))
                  context.read<DrawerProvider>().closeDrawer();
              },
            ),
            DrawerListTile(
              title: "비철금속 가격 정보",
              icon: Icons.area_chart_rounded,
              isSelected:
                  context.watch<MenuProvider>().menu == 3 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(3);
                if (Responsive.isMobile(context))
                  context.read<DrawerProvider>().closeDrawer();
              },
            ),
            DrawerListTile(
              title: "유가 정보",
              icon: Icons.data_exploration_rounded,
              isSelected:
                  context.watch<MenuProvider>().menu == 4 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(4);
                if (Responsive.isMobile(context))
                  context.read<DrawerProvider>().closeDrawer();
              },
            ),
            DrawerListTile(
              title: "금융 정보",
              icon: Icons.currency_exchange_rounded,
              isSelected:
              context.watch<MenuProvider>().menu == 5 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(5);
                if (Responsive.isMobile(context))
                  context.read<DrawerProvider>().closeDrawer();
              },
            )
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 15,
      leading: Icon(icon, color: isSelected ? primaryColor : dimColor),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? primaryColor : dimColor),
      ),
    );
  }
}
