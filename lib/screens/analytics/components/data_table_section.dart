import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

class DataTableSection extends StatelessWidget {
  final List<List<dynamic>> filteredData;

  DataTableSection({required this.filteredData});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth - (defaultPadding*2)
                ),
                child: DataTable(
                  columnSpacing: 20,
                  columns: _buildColumns(),
                  rows: _buildRows(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns() {
    return filteredData[0].map((column) {
      return DataColumn(
          label: Text(
        column.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    }).toList();
  }

  List<DataRow> _buildRows() {
    return filteredData.sublist(1).reversed.map((row) {
      return DataRow(
        cells: row.map((cell) {
          return DataCell(Text(cell.toString()));
        }).toList(),
      );
    }).toList();
  }
}
