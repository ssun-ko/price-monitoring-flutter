import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/screens/analytics/components/chart_area.dart';
import 'package:price/screens/analytics/components/search_area.dart';
import 'package:price/screens/analytics/components/table_grid.dart';
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
              SizedBox(height: defaultPadding),
              SearchArea(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ChartArea()),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text("엑셀 다운로드")),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: TableGrid()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
