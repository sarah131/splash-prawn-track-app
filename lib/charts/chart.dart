import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../helper/back.dart';
import '../login_page/auth.dart';
import '../theme/theme.dart';
import 'bottomDrawer.dart';

class chart extends StatefulWidget {
  const chart(
      {super.key,
      required this.wanted,
      required this.last,
      required this.pondname,
      required this.systemname,
      required this.sider});
  final String wanted;
  final String sider;
  final String pondname;
  final String systemname;
  final last;

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  String timestan = 'hour';

  DateTime datetime = DateTime.now();
  String? timeString;
  int? hour;
  int? min;

  @override
  void initState() {
    // TODO: implement initState

    hour = int.parse(DateFormat('HH').format(datetime).toString());
    min = int.parse(DateFormat('mm').format(datetime).toString());

    if (int.parse(DateFormat('HH').format(datetime).toString()) < 12) {
      timeString = 'AM';
    } else {
      timeString = 'PM';
    }
    super.initState();
  }

  DateTime parseDateTime(String dateTimeString) {
    return DateFormat("yyyy:MM:dd HH:mm:ss").parse(dateTimeString);
  }

  void _toggleDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MyBottomDrawer(
            pondname: widget.pondname,
            systemname: widget.systemname,
            header: widget.wanted);
      },
    );
  }

  late ChartSeriesController controller;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;

    final themeProvider = Provider.of<ThemeProvider>(context);
    Color color = themeProvider.isDark ? Colors.white : Colors.black;
    List<Widget> widgetList(li, found) => [
          lastvalue(width, height, li[0][1], found.last.key, widget.sider,
              isPortrait),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: isPortrait ? height * 0.015 : 0),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isPortrait
                      ? Padding(
                          padding: EdgeInsets.only(left: width * 0.04),
                          child: const Text(
                            'STATS',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    height: isPortrait ? null : height * 0.5,
                    child: Center(
                      child: li.isEmpty
                          ? const Text('Not enough data')
                          : SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                textStyle: TextStyle(color: color),
                                tooltipPosition: TooltipPosition.auto,
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      data[1].toStringAsFixed(2),
                                      style: TextStyle(color: color),
                                    ),
                                  );
                                },
                              ),
                              series: <ChartSeries>[
                                ColumnSeries<dynamic, num>(
                                  borderRadius: BorderRadius.circular(6),
                                  enableTooltip: true,
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 82, 177, 255),
                                        Color.fromARGB(255, 0, 140, 255)
                                      ]),
                                  dataSource: li,
                                  xValueMapper: (i, _) {
                                    return i[0];
                                  },
                                  yValueMapper: (i, _) {
                                    return i[1];
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
    double topTextSize = width * (isPortrait ? 0.07 : 0.04);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              top: height * 0.01, left: width * 0.02, right: width * 0.02),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('dataStore')
                .doc(Auth().currentUser!.email)
                .collection(widget.pondname)
                .doc(widget.systemname)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final found = snapshot.data!.data()!.entries.toList();
                if (found.isNotEmpty) {
                  final list = [];
                  found.sort((a, b) {
                    DateTime atime = parseDateTime(a.key);
                    DateTime btime = parseDateTime(b.key);
                    return atime.compareTo(btime);
                  });
                  for (var element in found) {
                    list.add(element.value);
                  }
                  String search = 'PH';
                  widget.wanted == 'temperature'
                      ? search = 'TEMP'
                      : widget.wanted == 'salanity'
                          ? search = 'TDS'
                          : widget.wanted == 'oxygen level'
                              ? search = 'DO'
                              : search = 'PH';

                  List li = [];
                  int length = list.length;
                  if (timestan == 'day') {
                    if (length > 250) {
                      for (var index = 0; index < 10; index++) {
                        double sum = 0;
                        for (var i = 1; i < 25; i++) {
                          sum +=
                              double.parse(list[length - i][search].toString());
                        }
                        li.add([index, (sum / 24)]);
                        length -= 25;
                      }
                    } else {
                      int run = length;
                      for (var index = 0; index < run / 25; index++) {
                        double sum = 0;
                        for (var i = 1; i < (run < 25 ? run : 25); i++) {
                          sum += double.parse(list[run - i][search].toString());
                        }
                        run -= 25;
                        li.add([index, (sum / 24)]);
                        if (run < 0) {
                          break;
                        }
                      }
                    }
                  } else {
                    li = [];
                    print(list.length);
                    if (length > 0) {
                      for (var index = 1;
                          index < (length < 25 ? length : 25);
                          index++) {
                        li.add([
                          index,
                          double.parse(
                              list[list.length - index][search].toString())
                        ]);
                      }
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      back(
                        text: 'Home',
                        width: 0,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: height * (isPortrait ? 0.015 : 0)),
                        alignment: Alignment.center,
                        child: Text(
                          widget.wanted.toUpperCase(),
                          style: TextStyle(
                              fontSize: topTextSize,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      shifter(width, height, color, themeProvider.isDark,
                          isPortrait),
                      Expanded(
                        child: isPortrait
                            ? Column(
                                children: widgetList(li, found) +
                                    [bottomButton('Previous Data')],
                              )
                            : SizedBox(
                                width: width,
                                child: Row(children: widgetList(li, found))),
                      ),
                    ],
                  );
                } else {
                  return Builder(builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        back(
                          text: "Home",
                        ),
                        Center(child: Text('NO data received yet!')),
                      ],
                    );
                  });
                }
              } else {
                return Center(
                  child: LoadingAnimationWidget.beat(
                    color: color,
                    size: 200,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget bottomButton(String text) {
    return GestureDetector(
      onTap: _toggleDrawer,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(255, 190, 190, 190),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Container lastvalue(double width, double height, double last, String time,
      var unit, bool isPortait) {
    List<String> dateTimeParts = time.split(" ");
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

    double header = width * (isPortait ? 0.05 : 0.025);
    double timer = width * (isPortait ? 0.04 : 0.0225);

    return Container(
      width: isPortait ? width : null,
      margin: EdgeInsets.only(
          top: height * 0.05,
          left: width * 0.04,
          right: width * 0.04,
          bottom: height * 0.05),
      decoration: BoxDecoration(
        border: isPortait
            ? const Border(
                bottom: BorderSide(color: Colors.grey),
              )
            : const Border(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last Value : ${last.toStringAsFixed(2)} $unit',
            style: TextStyle(fontSize: header, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Time: ${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}',
            style: TextStyle(
                fontSize: timer,
                fontWeight: FontWeight.w500,
                color: Colors.grey),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          isPortait
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: bottomButton('Previous Data'),
                ),
        ],
      ),
    );
  }

  Center shifter(
      double width, double height, Color data, theme, bool isPortrait) {
    double boxWidth = width * (isPortrait ? 0.65 : 0.35);
    double shifterSize = isPortrait ? 18 : 16;
    return Center(
      child: Container(
        // width: boxWidth,
        width: boxWidth,
        margin: EdgeInsets.only(
          top: height * 0.02,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 232, 232),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                timestan = 'hour';
              }),
              child: Container(
                  margin: EdgeInsets.only(
                      top: width * 0.01,
                      // left: width * 0.01,
                      bottom: width * 0.01),
                  decoration: BoxDecoration(
                      color: timestan == 'hour' ? data : Colors.transparent,
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Last 24 hours',
                    style: TextStyle(
                        fontSize: shifterSize, fontWeight: FontWeight.w500),
                  )),
            ),
            GestureDetector(
              onTap: () => setState(() {
                timestan = 'day';
              }),
              child: Container(
                margin: EdgeInsets.only(
                    top: width * 0.01,
                    // right: width * 0.01,
                    bottom: width * 0.01),
                decoration: BoxDecoration(
                    color: timestan == 'day' ? data : Colors.transparent,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(8),
                child: Text(
                  'Last 10 days',
                  style: TextStyle(
                      fontSize: shifterSize, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
