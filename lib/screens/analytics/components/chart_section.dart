import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/models/chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSection extends StatelessWidget {
  final List<List<dynamic>> data;
  final int menuId;

  const ChartSection({Key? key, required this.data, required this.menuId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SfCartesianChart(
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: bgColor,
                  textStyle: TextStyle(color: Colors.white),
                ),
                primaryXAxis: CategoryAxis(),
                series: _buildSeries()),
          ),
        ],
      ),
    );
  }

  List<CartesianSeries<dynamic, String>> _buildSeries() {
    List<CartesianSeries<dynamic, String>> seriesList = [];

    for (int i = 1; i < data[0].length; i++) {
      String seriesName = data[0][i];
      seriesList.add(
        SplineSeries<ChartData, String>(
          name: seriesName,
          dataSource: _getChartData(),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y[seriesName] ?? 0,
        ),
      );
    }

    return seriesList;
  }

  List<ChartData> _getChartData() {
    List<ChartData> seriesData = [];

    for (int i = 1; i < data.length; i++) {
      String x = data[i][0].toString();
      Map<String, double> y = {};

      for (int j = 1; j < data[i].length; j++) {
        y[data[0][j]] = double.tryParse(data[i][j].toString()) ?? 0.0;
      }

      seriesData.add(ChartData(x, y));
    }

    if (menuId == 3) {
      for (int i = 1; i < data[0].length; i++) {
        String seriesName = data[0][i];
        double minY = 10000000000;
        double maxY = 0;

        for (int j = 0; j < seriesData.length; j++) {
          if (seriesData[j].y[seriesName]! < minY)
            minY = seriesData[j].y[seriesName]!;
          if (seriesData[j].y[seriesName]! > maxY)
            maxY = seriesData[j].y[seriesName]!;
        }

        for (int j = 0; j < seriesData.length; j++) {
          seriesData[j].y[seriesName] =
              (seriesData[j].y[seriesName]! - minY) / (maxY - minY) * 100;
        }
      }
    }

    return seriesData;
  }
}
