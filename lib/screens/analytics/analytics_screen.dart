import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/screens/dashboard/components/header.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              )
            ],
          )
        ),
      ),
    );
  }
}