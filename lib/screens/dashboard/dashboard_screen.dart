import 'package:price/core/constants/color_constants.dart';
import 'package:price/responsive.dart';

import 'package:price/screens/dashboard/components/recent_forums.dart';
import 'package:flutter/material.dart';

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        RecentDiscussions(),
                        SizedBox(height: defaultPadding),
                        RecentDiscussions(),
                        if (!Responsive.isDesktop(context))
                          SizedBox(height: defaultPadding),
                        if (!Responsive.isDesktop(context)) RecentDiscussions(),
                      ],
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    SizedBox(width: defaultPadding),
                  if (Responsive.isDesktop(context))
                    Expanded(
                      flex: 2,
                      child: RecentDiscussions(),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
