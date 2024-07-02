import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/models/chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSection extends StatelessWidget {
  final List<List<dynamic>> data;

  const ChartSection({Key? key, required this.data}) : super(key: key);

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
          dataSource: _getChartData(i),
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y[seriesName] ?? 0,
        ),
      );
    }

    return seriesList;
  }

  List<ChartData> _getChartData(int index) {
    List<ChartData> seriesData = [];

    for (int i = 1; i < data.length; i++) {
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
