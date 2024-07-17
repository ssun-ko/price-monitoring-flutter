import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/models/chart_data_model.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OilWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        if (dataProvider.oilData.isEmpty) {
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
          return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetTitle(title: oilWidgetTitle),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - defaultPadding * 8,
                  width: double.infinity,
                  child: SfCartesianChart(
                    enableSideBySideSeriesPlacement: false,
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      color: bgColor,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    primaryXAxis: CategoryAxis(),
                    series: _buildSeries(dataProvider.oilData),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  List<BarSeries<dynamic, String>> _buildSeries(
    List<List<dynamic>> data,
  ) {
    List<BarSeries<dynamic, String>> seriesList = [];

    for (int i = 1; i < data.first.length; i++) {
      String seriesName = data.first[i];
      seriesList.add(BarSeries<ChartData, String>(
          name: seriesName,
          dataSource: _getChartData(data, i),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y[seriesName] ?? 0));
    }

    return seriesList;
  }

  List<ChartData> _getChartData(List<List<dynamic>> data, int index) {
    List<ChartData> seriesData = [];

    for (int i = 1; i < data.first.length; i++) {
      String x = data.first[i].toString();
      Map<String, double> y = {};

      y[data.first[i]] = double.tryParse(data.last[i].toString()) ?? 0.0;

      seriesData.add(ChartData(x, y));
    }

    return seriesData;
  }
}
