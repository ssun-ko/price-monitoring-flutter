import 'package:price/providers/drawer_provider.dart';
import 'package:price/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<DrawerProvider>().openDrawer)
      ],
    );
  }
}
