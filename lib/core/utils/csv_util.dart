import 'dart:convert' as convert;
import 'dart:html' as html;

import 'package:csv/csv.dart';

class CSVUtil {
  static Future<void> downloadCSV(
      List<List<dynamic>> data, String fileName) async {
    String csv = const ListToCsvConverter(
            fieldDelimiter: ',', eol: '\n', textDelimiter: '"')
        .convert(data);

    final bytes = convert.utf8.encode(csv);
    final blob = html.Blob([bytes], 'text/csv; charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
