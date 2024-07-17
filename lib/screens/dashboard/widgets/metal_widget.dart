import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/models/chart_data_model2.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.metalData.isEmpty) {
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
              WidgetTitle(title: metalWidgetTitle),
              SizedBox(
                height: 278,
                width: double.infinity,
                child: SfCartesianChart(
                    legend: Legend(isVisible: true),
                    plotAreaBorderColor: Colors.transparent,
                    tooltipBehavior: TooltipBehavior(
                        decimalPlaces: 2,
                        format: 'point.y',
                        enable: true,
                        color: bgColor,
                        textStyle: TextStyle(color: Colors.white)),
                    margin: EdgeInsets.zero,
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(isVisible: false),
                    series: <ColumnSeries>[
                      ColumnSeries<ChartData2, String>(
                          spacing: 0.1,
                          color: Colors.grey,
                          dataSource: _getChartData(dataProvider.metalData),
                          xValueMapper: (ChartData2 data, _) => data.x,
                          yValueMapper: (ChartData2 data, _) => data.y2,
                          name: dataProvider
                              .metalData[dataProvider.metalData.length - 2][0]
                              .toString()
                              .substring(0, 7)),
                      ColumnSeries<ChartData2, String>(
                          spacing: 0.1,
                          color: Colors.blueGrey,
                          dataSource: _getChartData(dataProvider.metalData),
                          xValueMapper: (ChartData2 data, _) => data.x,
                          yValueMapper: (ChartData2 data, _) => data.y,
                          name: dataProvider.metalData.last[0]
                              .toString()
                              .substring(0, 7))
                    ]),
              )
            ],
          ),
        );
      }
    });
  }

  List<ChartData2> _getChartData(List<List<dynamic>> data) {
    List<ChartData2> seriesData = [];

    for (int i = 1; i < data.last.length; i++) {
      String x = data[0][i].toString();

      double y = double.tryParse(data.last[i].toString()) ?? 0.0;
      double y2 = double.tryParse(data[data.length - 2][i].toString()) ?? 0.0;

      seriesData.add(ChartData2(x, y, y2));
    }
    return seriesData;
  }
}
