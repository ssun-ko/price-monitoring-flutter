import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/monthly_metal_data_provider.dart';
import 'package:price/screens/dashboard/components/header.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetalScreen extends StatefulWidget {
  @override
  _MetalScreenState createState() => _MetalScreenState();
}

class _MetalScreenState extends State<MetalScreen> {
  DateTime _startDate = DateTime(DateTime.now().year, 1);
  DateTime _endDate = DateTime.now();

  List<List<dynamic>> data = [];
  List<List<dynamic>> filteredData = [];

  void filterDataByDate(DateTime startDate, DateTime endDate) {
    DateFormat format = DateFormat('yyyy-MM');

    setState(() {
      filteredData = data.where((row) {
        if (row == data[0]) return true;
        DateTime date = format.parse(row[0]);
        return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
            (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
      }).toList();
    });
  }

  Future<void> downloadCSV() async {
    List<List<dynamic>> rows = filteredData;
    String csv = const ListToCsvConverter().convert(rows);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "data.csv")
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          '파일이 다운로드 됩니다.',
          style: TextStyle(color: Colors.white),
        )));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? startDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme(
                    brightness: Brightness.dark,
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    secondary: tintColor,
                    onSecondary: Colors.white,
                    error: Colors.red,
                    onError: Colors.white,
                    surface: secondaryColor,
                    onSurface: Colors.white)),
            child: child!,
          );
        },
        locale: const Locale('ko', 'KR'),
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2024, 1),
        lastDate: DateTime(2026, 12));

    if (startDate != null && startDate != _startDate) {
      setState(() {
        _startDate = startDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? endDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme(
                    brightness: Brightness.dark,
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    secondary: tintColor,
                    onSecondary: Colors.white,
                    error: Colors.red,
                    onError: Colors.white,
                    surface: secondaryColor,
                    onSurface: Colors.white)),
            child: child!,
          );
        },
        locale: const Locale('ko', 'KR'),
        context: context,
        initialDate: _endDate,
        firstDate: _startDate,
        lastDate: DateTime(2026, 12));

    if (endDate != null && endDate != _endDate) {
      setState(() {
        _endDate = endDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      data = context.read<MonthlyMetalDataProvider>().data;
      filterDataByDate(_startDate, _endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("조회기간", style: TextStyle(color: dimColor)),
                        SizedBox(
                          child: Row(
                            children: [
                              Row(
                                children: <Widget>[
                                  Text(
                                      "${DateFormat('yyyy-MM').format(_startDate)}"),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () =>
                                          _selectStartDate(context),
                                      icon: Icon(Icons.calendar_month))
                                ],
                              ),
                              Text("~"),
                              SizedBox(width: defaultPadding / 2),
                              Row(
                                children: <Widget>[
                                  Text(
                                      "${DateFormat('yyyy-MM').format(_endDate)}"),
                                  IconButton(
                                      color: Colors.white,
                                      onPressed: () => _selectEndDate(context),
                                      icon: Icon(Icons.calendar_month))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          filterDataByDate(_startDate, _endDate);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Text("검색"))
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                      child: SfCartesianChart(
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            SplineSeries<_MetalData, String>(
                                name: "철근",
                                dataSource: _getChartData(0),
                                xValueMapper: (_MetalData data, _) => data.date,
                                yValueMapper: (_MetalData data, _) =>
                                    data.rebar),
                            SplineSeries<_MetalData, String>(
                                name: "철광석",
                                dataSource: _getChartData(0),
                                xValueMapper: (_MetalData data, _) => data.date,
                                yValueMapper: (_MetalData data, _) =>
                                    data.iron_ore),
                            SplineSeries<_MetalData, String>(
                                name: "유연탄",
                                dataSource: _getChartData(0),
                                xValueMapper: (_MetalData data, _) => data.date,
                                yValueMapper: (_MetalData data, _) =>
                                    data.bituminous_coal),
                            SplineSeries<_MetalData, String>(
                                name: "철스크랩",
                                dataSource: _getChartData(0),
                                xValueMapper: (_MetalData data, _) => data.date,
                                yValueMapper: (_MetalData data, _) =>
                                    data.scrap)
                          ]),
                    )
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        downloadCSV();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text("엑셀 다운로드")),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: DataTable(
                        columns: filteredData[0]
                            .map((column) => DataColumn(
                                  label: Text(column.toString()),
                                ))
                            .toList(),
                        rows: filteredData
                            .sublist(1)
                            .map((row) => DataRow(
                                cells: row
                                    .map((cell) =>
                                        DataCell(Text(cell.toString())))
                                    .toList()))
                            .toList()),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<_MetalData> _getChartData(int index) {
    List<_MetalData> seriesData = [];
    DateFormat format = DateFormat('yyyy-MM');

    for (int i = 1; i < filteredData.length; i++) {
      dynamic date = filteredData[i][0];
      dynamic rebar = filteredData[i][1];
      dynamic iron_ore = filteredData[i][2];
      dynamic bituminous_coal = filteredData[i][3];
      dynamic scrap = filteredData[i][4];

      seriesData.add(_MetalData(date.toString(), rebar.toDouble(),
          iron_ore.toDouble(), bituminous_coal.toDouble(), scrap.toDouble()));
    }

    return seriesData;
  }
}

class _MetalData {
  _MetalData(
      this.date, this.rebar, this.iron_ore, this.bituminous_coal, this.scrap);

  final String date;
  final double rebar;
  final double iron_ore;
  final double bituminous_coal;
  final double scrap;
}
