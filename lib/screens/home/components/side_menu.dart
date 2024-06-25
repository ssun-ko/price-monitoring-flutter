import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/menu_provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              title: "대시보드",
              icon: Icons.dashboard,
              isSelected: context.watch<MenuProvider>().menu == 1 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(1);
              },
            ),
            DrawerListTile(
              title: "데이터 조회",
              icon: Icons.analytics,
              isSelected: context.watch<MenuProvider>().menu == 2 ? true : false,
              press: () {
                context.read<MenuProvider>().changeMenu(2);
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
      leading: Icon(icon, color: isSelected? primaryColor : dimColor),
      title: Text(
        title,
        style: TextStyle(color: isSelected? primaryColor : dimColor),
      ),
    );
  }
}
