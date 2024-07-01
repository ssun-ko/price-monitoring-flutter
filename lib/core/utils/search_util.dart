import 'package:intl/intl.dart';

class SearchUtil {
  List<List<dynamic>> filterDataByDate(List<List<dynamic>> data,
      DateTime startDate, DateTime endDate, bool isMonthly) {
    List<List<dynamic>> filteredData = [];
    DateFormat format =
        isMonthly ? DateFormat('yyyy-MM') : DateFormat('yyyy-MM-dd');

    filteredData = data.where((row) {
      if (row == data[0]) return true;
      DateTime date = format.parse(row[0]);
      return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
          (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
    }).toList();

    return filteredData;
  }
}
