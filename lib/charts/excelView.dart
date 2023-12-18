import 'package:flutter/material.dart';

class ExcelDataPage extends StatefulWidget {
  final List<List<dynamic>> excelData;

  ExcelDataPage({required this.excelData});

  @override
  _ExcelDataPageState createState() => _ExcelDataPageState();
}

class _ExcelDataPageState extends State<ExcelDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Data'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: widget.excelData[0]
                .map((cellValue) =>
                    DataColumn(label: Text(cellValue.toString())))
                .toList(),
            rows: List.generate(
              widget.excelData.length - 1, // Exclude header row
              (index) {
                var rowData = widget.excelData[index + 1]; // Skip header row
                return DataRow(
                  cells: rowData
                      .map((cellValue) => DataCell(Text(cellValue.toString())))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
