import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

class TableGrid extends StatelessWidget {
  const TableGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: DataTable(
          columns: [
            DataColumn(label: Text('A')),
            DataColumn(label: Text('B')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('A1')),
              DataCell(Text('B1')),
            ]),
            DataRow(cells: [
              DataCell(Text('A2')),
              DataCell(Text('B2')),
            ]),
          ],
        ),
      );
  }
}
