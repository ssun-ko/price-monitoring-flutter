import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

class DataTableSection extends StatelessWidget {
  final List<List<dynamic>> filteredData;

  DataTableSection({required this.filteredData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: DataTable(
              columnSpacing: 20,
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return filteredData[0].map((column) {
      return DataColumn(
        label: Expanded(
          child: Text(
            column.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildRows() {
    return filteredData.sublist(1).map((row) {
      return DataRow(
        cells: row.map((cell) {
          return DataCell(Text(cell.toString()));
        }).toList(),
      );
    }).toList();
  }
}
