import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/responsive.dart';
import 'package:price/screens/dashboard/widgets/detail_widget.dart';
import 'package:price/screens/dashboard/widgets/dollar_widget.dart';
import 'package:price/screens/dashboard/widgets/metal_widget.dart';
import 'package:price/screens/dashboard/widgets/oil_widget.dart';

import 'components/header.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              DetailWidget(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 965,
                    child: Column(
                      children: [
                        DollarWidget(),
                        SizedBox(height: defaultPadding),
                        MetalWidget(),
                        if (!Responsive.isDesktop(context))
                          SizedBox(height: defaultPadding),
                        if (!Responsive.isDesktop(context)) OilWidget()
                      ]
                    )
                  ),
                  if (Responsive.isDesktop(context))
                    SizedBox(width: defaultPadding),
                  if (Responsive.isDesktop(context))
                    Expanded(flex: 638, child: OilWidget()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
