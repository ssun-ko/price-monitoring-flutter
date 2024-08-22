import 'package:intl/intl.dart';

class SearchUtil {
  List<List<dynamic>> filterDataByDate(List<List<dynamic>> data,
      DateTime startDate, DateTime endDate, bool isMonthly) {
    List<List<dynamic>> filteredData = [];
    DateFormat format =
    isMonthly ? DateFormat('yyyy-MM') : DateFormat('yyyy-MM-dd');

    DateTime startOfDay = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    DateTime endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    filteredData = data.where((row) {
      if (row == data[0]) return true;
      DateTime date = format.parse(row[0]);
      return (date.isAfter(startOfDay) || date.isAtSameMomentAs(startOfDay)) &&
          (date.isBefore(endOfDay) || date.isAtSameMomentAs(endOfDay));
    }).toList();

    return filteredData;
  }
}