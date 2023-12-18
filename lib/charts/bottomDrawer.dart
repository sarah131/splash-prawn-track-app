// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;
import 'package:csv/csv.dart';

import '../login_page/auth.dart';
import 'excelView.dart';
import 'save.dart';
import 'share.dart';
import 'open.dart';

class MyBottomDrawer extends StatefulWidget {
  final String pondname;
  final String systemname;
  final String header;

  const MyBottomDrawer(
      {super.key,
      required this.pondname,
      required this.systemname,
      required this.header});
  @override
  State<MyBottomDrawer> createState() => _MyBottomDrawerState();
}

class _MyBottomDrawerState extends State<MyBottomDrawer> {
  String? errorText;
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  final TextEditingController _startDateTimeController =
      TextEditingController();
  final TextEditingController _endDateTimeController = TextEditingController();

  Future _generateExcelFile(List data, String todo) async {
    List<List<String>> body = [];
    List<String> header = [
      'SNO',
      'Date',
      'Oxygen Level',
      'PH Level',
      'Temperature',
      'Salinity'
    ];
    body.add(header);
    for (var item in data) {
      int index = data.indexOf(item);
      List<String> sensorValues = [];
      sensorValues.add(index.toString());
      sensorValues.add(item.key);
      final values = item.value;
      sensorValues.add(values['DO']);
      sensorValues.add(values['PH']);
      sensorValues.add(values['TEMP']);
      sensorValues.add(values['TDS']);
      body.add(sensorValues);
    }
    // exportCSV.myCSV(header, body);
    String csv = const ListToCsvConverter().convert(body);
    print(csv);
    final File file =
        await save.saveStringFile(filename: widget.header, bytes: csv);
    todo == 'share'
        ? share.shareFile(file, widget.header)
        : todo == 'download'
            ? open.openFile(file.path)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExcelDataPage(
                          excelData: body,
                        )));
  }

  dateTimeConverter(String dateString) {
    List<String> dateTimeParts = dateString.split(" ");
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];

    List<String> dateParts = datePart.split(":");
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    List<String> timeParts = timePart.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    DateTime dateTime = DateTime(year, month, day, hour, minute, second);

    return dateTime;
  }

  Future searchData({required String todo}) async {
    final snapRef = await FirebaseFirestore.instance
        .collection('dataStore')
        .doc(Auth().currentUser!.email)
        .collection(widget.pondname)
        .doc(widget.systemname)
        .get();
    final data = await snapRef.data()!.entries.toList();
    final filteredData = data.where((map) {
      final DateTime dateTime = dateTimeConverter(map.key);
      return dateTime.isAfter(_startDateTime!) &&
          dateTime.isBefore(_endDateTime!);
    }).toList();
    // final filteredValues = filteredData.map((e) => e.value);
    _generateExcelFile(filteredData, todo);
    // return filteredData;
  }

  Future<void> _startSelectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startDateTimeController.text =
              DateFormat('yyyy:MM:dd HH:mm:ss').format(_startDateTime!);
        });
      }
    }
  }

  Future<void> _endSelectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _endDateTimeController.text =
              DateFormat('yyyy:MM:dd HH:mm:ss').format(_endDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.03),
            child: Text(
              'Download Previous Data',
              style: TextStyle(
                  fontSize: width * 0.05, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          ListTile(
            title: TextFormField(
              controller: _startDateTimeController,
              readOnly: true,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
            leading: Text('Start Date',
                style: TextStyle(
                    fontSize: width * 0.04, fontWeight: FontWeight.w600)),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _startSelectDateTime,
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _endDateTimeController,
              readOnly: true,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
            leading: Text('End Date',
                style: TextStyle(
                    fontSize: width * 0.04, fontWeight: FontWeight.w600)),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _endSelectDateTime,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          errorText != null ? Text(errorText!) : const SizedBox(),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: const Text('Download'),
                  onPressed: () => setState(() {
                        if (_startDateTime != null && _endDateTime != null) {
                          errorText = null;
                          searchData(todo: 'download');
                        } else {
                          errorText = 'Kindly Enter the Start and End Date';
                        }
                      })),
              ElevatedButton(
                  child: const Text('Share'),
                  onPressed: () => setState(() {
                        if (_startDateTime != null && _endDateTime != null) {
                          errorText = null;
                          searchData(todo: 'share');
                        } else {
                          errorText = 'Kindly Enter the Start and End Date';
                        }
                      })),
              ElevatedButton(
                  child: const Text('Show'),
                  onPressed: () => setState(() {
                        if (_startDateTime != null && _endDateTime != null) {
                          errorText = null;
                          searchData(todo: 'show');
                        } else {
                          errorText = 'Kindly Enter the Start and End Date';
                        }
                      })),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
