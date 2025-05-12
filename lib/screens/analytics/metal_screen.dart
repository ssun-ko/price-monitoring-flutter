import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/core/themes/custom_datepicker_theme.dart';
import 'package:price/core/utils/csv_util.dart';
import 'package:price/core/utils/search_util.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/screens/analytics/components/chart_section.dart';
import 'package:price/screens/analytics/components/data_table_section.dart';
import 'package:price/screens/analytics/components/download_snackbar.dart';
import 'package:price/screens/analytics/components/excel_download_button.dart';
import 'package:price/screens/analytics/components/search_section.dart';
import 'package:price/screens/dashboard/components/header.dart';
import 'package:provider/provider.dart';

class MetalScreen extends StatefulWidget {
  @override
  _MetalScreenState createState() => _MetalScreenState();
}

class _MetalScreenState extends State<MetalScreen> {
  DateTime _startDate = new DateTime(2011, 7, 1);
  DateTime _endDate = DateTime.now();

  List<List<dynamic>> data = [];
  List<List<dynamic>> filteredData = [];

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? startDate = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: CustomDatePickerTheme.theme,
            child: child!,
          );
        },
        locale: const Locale('ko', 'KR'),
        context: context,
        initialDate: _startDate,
        firstDate: _startDate,
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
            data: CustomDatePickerTheme.theme,
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
      data = context.read<DataProvider>().metalData;
      filteredData =
          SearchUtil().filterDataByDate(data, _startDate, _endDate, true);
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(children: [
                    SearchSection(
                        startDate: _startDate,
                        endDate: _endDate,
                        onStartDatePressed: () => _selectStartDate(context),
                        onEndDatePressed: () => _selectEndDate(context),
                        isMonthly: true),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filteredData = SearchUtil().filterDataByDate(
                                data, _startDate, _endDate, true);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(searchButtonLabel))
                  ])),
              SizedBox(height: defaultPadding),
              ChartSection(
                  data: filteredData,
                  menuId: context.watch<MenuProvider>().menu),
              SizedBox(height: defaultPadding),
              Text("철강 가격의 다음 업데이트 예정일은 2025년 9월 17일입니다."),
              SizedBox(height: defaultPadding),
              ExcelDownloadButton(onPressed: () {
                CSVUtil.downloadCSV(data, fileName);
                DownloadSnackBar.showSnackBar(context);
              }),
              SizedBox(height: defaultPadding),
              DataTableSection(filteredData: filteredData)
            ],
          ),
        ),
      ),
    );
  }
}
