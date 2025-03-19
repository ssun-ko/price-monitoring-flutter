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

class DollarScreen extends StatefulWidget {
  @override
  _DollarScreenState createState() => _DollarScreenState();
}

class _DollarScreenState extends State<DollarScreen> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
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
      data = context.read<DataProvider>().dollarData;
      filteredData =
          SearchUtil().filterDataByDate(data, _startDate, _endDate, false);
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
                    SearchSection(
                        startDate: _startDate,
                        endDate: _endDate,
                        onStartDatePressed: () => _selectStartDate(context),
                        onEndDatePressed: () => _selectEndDate(context),
                        isMonthly: false),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filteredData = SearchUtil().filterDataByDate(
                                data, _startDate, _endDate, false);
                          });
                          ;
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Text(searchButtonLabel))
                  ],
                ),
              ),
              SizedBox(height: defaultPadding),
              ChartSection(
                  data: filteredData,
                  menuId: context.watch<MenuProvider>().menu),
              SizedBox(height: defaultPadding),
              Text("🥴🥴 금리는 실시간 데이터와 2일 이상 차이날 수 있습니다."),
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
