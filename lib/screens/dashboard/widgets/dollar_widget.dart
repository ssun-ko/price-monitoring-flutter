import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/models/chart_data_model.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DollarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.dollarData.isEmpty) {
        return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: CircularProgressIndicator(),
            ));
      } else {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetTitle(title: dollarWidgetTitle),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: SfCartesianChart(
                    legend: Legend(isVisible: false),
                    plotAreaBorderColor: Colors.transparent,
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      color: bgColor,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    margin: EdgeInsets.zero,
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(isVisible: false),
                    series: _buildSeries(dataProvider.dollarData)),
              )
            ],
          ),
        );
      }
    });
  }

  List<CartesianSeries<dynamic, String>> _buildSeries(
      List<List<dynamic>> data) {
    List<CartesianSeries<dynamic, String>> seriesList = [];

    final LinearGradient gradientColors = LinearGradient(colors: <Color>[
      Colors.grey.withOpacity(0.2),
      Colors.grey.withOpacity(0.1),
      Colors.transparent
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

    for (int i = 1; i < data[0].length; i++) {
      String seriesName = "환율";
      seriesList.add(
        AreaSeries<ChartData, String>(
          gradient: gradientColors,
          borderDrawMode: BorderDrawMode.top,
          borderColor: Colors.grey,
          name: seriesName,
          dataSource: _getChartData(data, i),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y[seriesName] ?? 0,
        ),
      );
    }

    return seriesList;
  }

  List<ChartData> _getChartData(List<List<dynamic>> data, int index) {
    List<ChartData> seriesData = [];

    // 최근 30일 데이터 조회, 데이터 30일 미만인 경우 전체
    int startIndex = data.length - 30;
    startIndex = startIndex < 0 ? 1 : startIndex;

    for (int i = startIndex; i < data.length; i++) {
      String x = data[i][0].toString();
      Map<String, double> y = {};

      y[data[0][1]] = double.tryParse(data[i][1].toString()) ?? 0.0;
      seriesData.add(ChartData(x, y));
    }
    return seriesData;
  }
}
