import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/utils/search_util.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';

class DollarCard extends StatelessWidget {
  final int cardNumber;

  DollarCard({required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.dollarData.isEmpty) {
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
                color: cardNumber == 1 ? Colors.blueAccent : Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_getIcon(), size: 30),
                  SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      Text(_getValue(dataProvider),
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold)),
                      Text(' %', style: Theme.of(context).textTheme.labelLarge)
                    ],
                  ),
                  WidgetTitle(title: _getWidgetTitle()),
                  SizedBox(height: defaultPadding / 3),
                  Row(
                    children: [
                      Text(DateTime.now().month.toString() + "월 평균 "),
                      Text(_getAverage(dataProvider))
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 1,
                    width: 20,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white))),
                  )
                ],
              )),
        );
      }
    });
  }

  String _getValue(DataProvider dataProvider) {
    return dataProvider.dollarData.last[cardNumber + 1].toString();
  }

  IconData _getIcon() {
    return cardNumber == 1
        ? Icons.wallet_rounded
        : Icons.account_balance_rounded;
  }

  String _getAverage(DataProvider dataProvider) {
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime endDate = DateTime.now();
    List<List<dynamic>> thisMonthData = SearchUtil()
        .filterDataByDate(dataProvider.dollarData, startDate, endDate, false);

    final formatter = NumberFormat('##.##');

    double sum = 0.0;

    for (int i = 1; i < thisMonthData.length; i++) {
      sum +=
          double.tryParse(thisMonthData[i][cardNumber + 1].toString()) ?? 0.0;
    }

    return formatter.format(sum / (thisMonthData.length - 1));
  }

  String _getWidgetTitle() {
    return cardNumber == 1 ? "기준금리" : "KORIBOR";
  }
}
