import 'dart:convert' as convert;
import 'dart:html' as html;
import 'package:csv/csv.dart';

class CSVUtil {
  static Future<void> downloadCSV(
      List<List<dynamic>> data, String fileName) async {
    
    String csv = const ListToCsvConverter(
        fieldDelimiter: ',', eol: '\n', textDelimiter: '"')
        .convert(data);

    const utf8BOM = '\uFEFF';
    final csvWithBOM = utf8BOM + csv;

    final bytes = convert.utf8.encode(csvWithBOM);
    final blob = html.Blob([bytes], 'text/csv; charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}