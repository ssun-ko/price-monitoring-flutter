import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

const List<String> list = <String>['철강', '시멘트', '레미콘'];

class SearchArea extends StatefulWidget {
  const SearchArea({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  String _dropDownValue = list.first;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

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
                    surface: bgColor,
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
                    surface: bgColor,
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("데이터 항목", style: TextStyle(color: dimColor)),
              SizedBox(
                height: 50,
                child: DropdownButton<String>(
                  value: _dropDownValue,
                  items: list.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _dropDownValue = value!;
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(width: defaultPadding * 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("조회기간", style: TextStyle(color: dimColor)),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Row(
                      children: <Widget>[
                        Text("${_startDate.toLocal()}".split(' ')[0]),
                        IconButton(
                            onPressed: () => _selectStartDate(context),
                            icon: Icon(Icons.calendar_month))
                      ],
                    ),
                    Text("~"),
                    SizedBox(width: defaultPadding / 2),
                    Row(
                      children: <Widget>[
                        Text("${_endDate.toLocal()}".split(' ')[0]),
                        IconButton(
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Text("검색"))
        ],
      ),
    );
  }
}
