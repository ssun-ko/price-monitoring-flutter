import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/data_provider.dart';
import 'package:provider/provider.dart';

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
        columns:
            context.watch<DataProvider>().data[0].map((column) => DataColumn(
                  label: Text(column.toString()),
                )).toList(),
        rows: context.watch<DataProvider>().data.sublist(1).map((row) => DataRow(
          cells: row.map((cell) => DataCell(
            Text(cell.toString())
          )).toList()
        )).toList()
      ),
    );
  }
}
