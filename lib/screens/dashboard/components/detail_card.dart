import 'package:flutter/material.dart';
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
                ])
              ])),
        );
      }
    });
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
        return Icons.person_rounded;
      case 2:
        return Icons.chat_bubble_rounded;
      case 3:
        return Icons.star_rounded;
      case 4:
        return Icons.heart_broken_rounded;
      default:
        return Icons.doorbell_rounded;
    }
  }

  String _getWidgetLabel() {
    switch (cardNumber) {
      case 1:
      case 2:
      case 3:
        return "일간";
      default:
        return "월간";
    }
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
        return "철근";
      case 5:
        return "철광석";
      default:
        return "";
    }
  }
}
