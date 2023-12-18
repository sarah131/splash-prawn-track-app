import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class wisherWidget extends StatefulWidget {
  @override
  State<wisherWidget> createState() => _wisherWidgetState();
}

class _wisherWidgetState extends State<wisherWidget> {
  String? wisher;
  @override
  void initState() {
    super.initState();

    DateTime datetime = DateTime.now();
    int hour = int.parse(DateFormat('HH').format(datetime));
    if (hour >= 3 && hour < 12) {
      wisher = 'morning';
    } else if (hour >= 12 && hour < 18) {
      wisher = 'afternoon';
    } else if (hour >= 18 && hour < 24) {
      wisher = 'evening';
    } else {
      wisher = 'night';
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    double picSize = width * (isPortrait ? 0.12 : 0.06);
    double wisherTextSize = width * (isPortrait ? 0.055 : 0.035);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.account_circle,
          size: picSize,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          "Good $wisher",
          style: TextStyle(
            fontFamily: "SF-Pro",
            fontSize: wisherTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
