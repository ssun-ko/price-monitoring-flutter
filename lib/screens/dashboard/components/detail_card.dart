import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/models/chart_data_model.dart';
import 'package:price/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailCard extends StatelessWidget {
  final int cardNumber;

  DetailCard({required this.cardNumber});

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
      } else {
        return Expanded(
          child: Container(
            height: 200,
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getWidgetTitle()),
                SizedBox(height: defaultPadding / 2),
                Text(_getTodayPrice(dataProvider),
                    style: Theme.of(context).textTheme.titleLarge),
                _buildPriceRow(dataProvider),
                _buildChartWidget(dataProvider)
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildChartWidget(DataProvider dataProvider) {
    // gradients for area chart
    final LinearGradient gradientColors = LinearGradient(
        colors: <Color>[
          _getPriceShift(dataProvider)["diff"].toString().contains('-')
              ? Colors.blueAccent.withOpacity(0.2)
              : Colors.redAccent.withOpacity(0.2),
          _getPriceShift(dataProvider)["diff"].toString().contains('-')
              ? Colors.blueAccent.withOpacity(0.1)
              : Colors.redAccent.withOpacity(0.1),
          Colors.transparent
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);

    return Expanded(
        child: SfCartesianChart(
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(
              decimalPlaces: 0,
              enable: true,
              color: bgColor,
              textStyle: TextStyle(color: Colors.white)
            ),
            plotAreaBorderColor: Colors.transparent,
            primaryXAxis: CategoryAxis(isVisible: false),
            primaryYAxis: NumericAxis(isVisible: false),
            margin: EdgeInsets.zero,
            series: [
          AreaSeries<ChartData, String>(
              gradient: gradientColors,
              borderDrawMode: BorderDrawMode.top,
              borderColor:
                  _getPriceShift(dataProvider)["diff"].toString().contains('-')
                      ? Colors.blueAccent
                      : Colors.redAccent,
              borderWidth: 2,
              name: _getChartSeriesName(dataProvider),
              dataSource: _getChartData(dataProvider),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) =>
                  data.y[_getChartSeriesName(dataProvider)] ?? 0)
        ]));
  }

  String _getChartSeriesName(DataProvider dataProvider) {
    switch (cardNumber) {
      case 1:
        return dataProvider.oilData[0][1].toString();
      case 2:
        return dataProvider.noMetalData[0][1].toString();
      case 3:
        return dataProvider.noMetalData[0][2].toString();
      case 4:
        return dataProvider.noMetalData[0][5].toString();
      case 5:
        return dataProvider.noMetalData[0][6].toString();
      default:
        return "";
    }
  }

  List<ChartData> _getChartData(DataProvider dataProvider) {
    List<ChartData> seriesData = [];

    switch (cardNumber) {
      case 1:
        List<ChartData> seriesData = [];
        List<dynamic> data = dataProvider.oilData;

        // 최근 30일 데이터 조회, 데이터 30일 미만인 경우 전체
        int startIndex = data.length - 30;
        startIndex = startIndex < 0 ? 1 : startIndex;

        for (int i = startIndex; i < data.length; i++) {
          String x = data[i][0].toString();
          Map<String, double> y = {};

          for (int j = 1; j < data[i].length; j++) {
            y[data[0][j]] = double.tryParse(data[i][j].toString()) ?? 0.0;
          }

          seriesData.add(ChartData(x, y));
        }

        return seriesData;
      default:
        List<ChartData> seriesData = [];
        List<dynamic> data = dataProvider.noMetalData;

        // 최근 30일 데이터 조회, 데이터 30일 미만인 경우 전체
        int startIndex = data.length - 30;
        startIndex = startIndex < 0 ? 1 : startIndex;

        for (int i = startIndex; i < data.length; i++) {
          String x = data[i][0].toString();
          Map<String, double> y = {};

          for (int j = 1; j < data[i].length; j++) {
            y[data[0][j]] = double.tryParse(data[i][j].toString()) ?? 0.0;
          }

          seriesData.add(ChartData(x, y));
        }

        return seriesData;
    }
  }

  Widget _buildPriceRow(DataProvider dataProvider) {
    Map<String, String> priceShift = _getPriceShift(dataProvider);
    String diffSymbol =
        priceShift["diff"].toString().contains('-') ? "▼ " : "▲ ";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          diffSymbol,
          style: TextStyle(
            color: priceShift["diff"].toString().contains('-')
                ? Colors.blueAccent
                : Colors.redAccent,
          ),
        ),
        Text(
          "${priceShift["diff"]}  ${priceShift["percent"]}",
          style: TextStyle(
            color: priceShift["diff"].toString().contains('-')
                ? Colors.blueAccent
                : Colors.redAccent,
          ),
        ),
      ],
    );
  }

  String _getTodayPrice(DataProvider dataProvider) {
    final formatter = NumberFormat('#,###');

    switch (cardNumber) {
      case 1:
        return formatter.format(dataProvider.oilData.last[1]);
      case 2:
        return formatter.format(dataProvider.noMetalData.last[1]);
      case 3:
        return formatter.format(dataProvider.noMetalData.last[2]);
      case 4:
        return formatter.format(dataProvider.noMetalData.last[5]);
      case 5:
        return formatter.format(dataProvider.noMetalData.last[6]);
      default:
        return "0.0";
    }
  }

  Map<String, String> _getPriceShift(DataProvider dataProvider) {
    Map<String, String> data = {};
    List<double> todayValues = [
      dataProvider.oilData.last[1],
      dataProvider.noMetalData.last[1],
      dataProvider.noMetalData.last[2],
      dataProvider.noMetalData.last[5],
      dataProvider.noMetalData.last[6],
    ];

    List<double> yesterdayValues = [
      dataProvider.oilData[dataProvider.oilData.length - 2][1],
      dataProvider.noMetalData[dataProvider.noMetalData.length - 2][1],
      dataProvider.noMetalData[dataProvider.noMetalData.length - 2][2],
      dataProvider.noMetalData[dataProvider.noMetalData.length - 2][5],
      dataProvider.noMetalData[dataProvider.noMetalData.length - 2][6],
    ];

    double todayValue = todayValues[cardNumber - 1];
    double yesterdayValue = yesterdayValues[cardNumber - 1];

    data["diff"] = (todayValue - yesterdayValue).toStringAsFixed(2);
    data["percent"] =
        ((todayValue - yesterdayValue) / todayValue * 100).toStringAsFixed(2) +
            "%";

    return data;
  }

  String _getWidgetTitle() {
    switch (cardNumber) {
      case 1:
        return "유가 (원/L)";
      case 2:
        return "구리 (달러/톤)";
      case 3:
        return "알루미늄 (달러/톤)";
      case 4:
        return "니켈 (달러/톤)";
      case 5:
        return "주석 (달러/톤)";
      default:
        return "";
    }
  }
}
