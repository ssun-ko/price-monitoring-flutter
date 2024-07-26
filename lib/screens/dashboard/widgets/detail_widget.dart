import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/responsive.dart';
import 'package:price/screens/dashboard/components/detail_card.dart';
import 'package:price/screens/dashboard/components/dollar_card.dart';
import 'package:provider/provider.dart';

class DetailWidget extends StatelessWidget {
  final double iconBackgroundOpacity = 0.2;
  final double iconRadius = 8;
  final double iconSize = 20;

  final Color oilIconColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.metalData.isEmpty ||
          dataProvider.noMetalData.isEmpty ||
          dataProvider.oilData.isEmpty) {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (Responsive.isDesktop(context)) {
        return Container(
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  DollarCard(cardNumber: 1),
                  SizedBox(width: defaultPadding),
                  DollarCard(cardNumber: 2)
                ],
              ),
            ),
            SizedBox(width: defaultPadding),
            DetailCard(cardNumber: 1),
            SizedBox(width: defaultPadding),
            DetailCard(cardNumber: 2),
            SizedBox(width: defaultPadding),
            DetailCard(cardNumber: 3),
            SizedBox(width: defaultPadding),
            DetailCard(cardNumber: 4)
          ]),
        );
      } else {
        return Container(
            height: 1000,
            child: Column(children: [
              Row(
                children: [
                  DollarCard(cardNumber: 1),
                  SizedBox(width: defaultPadding),
                  DollarCard(cardNumber: 2),
                ],
              ),
              SizedBox(height: defaultPadding),
              DetailCard(cardNumber: 1),
              SizedBox(height: defaultPadding),
              DetailCard(cardNumber: 2),
              SizedBox(height: defaultPadding),
              DetailCard(cardNumber: 3),
              SizedBox(height: defaultPadding),
              DetailCard(cardNumber: 4)
            ]));
      }
    });
  }
}
