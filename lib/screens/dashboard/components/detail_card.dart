import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';

class DetailCard extends StatelessWidget {
  final int cardNumber;

  DetailCard({required this.cardNumber});

  final double iconBackgroundOpacity = 0.2;
  final double iconRadius = 8;
  final double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.metalData.isEmpty ||
          dataProvider.nometalData.isEmpty ||
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
      } else {
        return Expanded(
          child: Container(
              height: 200,
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(children: [
                Row(children: [
                  Container(
                      padding: EdgeInsets.all(iconRadius),
                      decoration: BoxDecoration(
                        color: _getWidgetIconColor()
                            .withOpacity(iconBackgroundOpacity),
                        borderRadius:
                            BorderRadius.all(Radius.circular(iconRadius)),
                      ),
                      child: Icon(
                          size: iconSize,
                          _getWidgetIcon(),
                          color: _getWidgetIconColor())),
                  SizedBox(width: defaultPadding),
                  WidgetTitle(title: _getWidgetTitle()),
                  Spacer(),
                  Text(_getWidgetLabel())
                ]),
                SizedBox(height: defaultPadding),
                Row(children: [
                  Text(_getTodayPrice(dataProvider),
                      style: Theme.of(context).textTheme.titleLarge)
                ])
              ])),
        );
      }
    });
  }

  String _getTodayPrice(DataProvider dataProvider) {
    final formatter = NumberFormat('#,###');

    switch (cardNumber) {
      case 1:
        return formatter.format(dataProvider.oilData.last[1]).toString();
      case 2:
        return formatter.format(dataProvider.nometalData.last[1]).toString();
      case 3:
        return formatter.format(dataProvider.nometalData.last[2]).toString();
      case 4:
        return formatter.format(dataProvider.nometalData.last[5]).toString();
      case 5:
        return formatter.format(dataProvider.nometalData.last[6]).toString();
      default:
        return "0.0";
    }
  }

  Color _getWidgetIconColor() {
    switch (cardNumber) {
      case 1:
        return Colors.lightBlueAccent;
      case 2:
        return Colors.deepPurpleAccent;
      case 3:
        return Colors.yellowAccent;
      case 4:
        return Colors.redAccent;
      default:
        return Colors.lightGreenAccent;
    }
  }

  IconData _getWidgetIcon() {
    switch (cardNumber) {
      case 1:
        return Icons.local_gas_station;
      case 2:
        return Icons.electrical_services;
      case 3:
        return Icons.lightbulb;
      case 4:
        return Icons.science;
      default:
        return Icons.kitchen;
    }
  }

  String _getWidgetLabel() {
    return "일간";
  }

  String _getWidgetTitle() {
    switch (cardNumber) {
      case 1:
        return "유가";
      case 2:
        return "구리";
      case 3:
        return "알루미늄";
      case 4:
        return "니켈";
      case 5:
        return "주석";
      default:
        return "";
    }
  }
}
