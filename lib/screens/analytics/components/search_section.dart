import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';

class SearchSection extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onStartDatePressed;
  final VoidCallback onEndDatePressed;
  final bool isMonthly;

  SearchSection(
      {required this.startDate,
      required this.endDate,
      required this.onStartDatePressed,
      required this.onEndDatePressed,
      required this.isMonthly});

  @override
  Widget build(BuildContext context) {
    final String dateFormat = isMonthly ? "yyyy-MM" : "yyyy-MM-dd";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(searchLabel, style: TextStyle(color: dimColor)),
        Row(
          children: [
            Row(
              children: <Widget>[
                Text("${DateFormat(dateFormat).format(startDate)}"),
                IconButton(
                  color: Colors.white,
                  onPressed: onStartDatePressed,
                  icon: Icon(Icons.calendar_month),
                ),
              ],
            ),
            Text("~"),
            SizedBox(width: defaultPadding / 2),
            Row(
              children: <Widget>[
                Text("${DateFormat(dateFormat).format(endDate)}"),
                IconButton(
                  color: Colors.white,
                  onPressed: onEndDatePressed,
                  icon: Icon(Icons.calendar_month),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
