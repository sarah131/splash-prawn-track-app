import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/circular.dart';
import '../helper/flask.dart';
import '../helper/linear.dart';
import '../helper/phind.dart';
import 'card1.dart';
import 'card2.dart';

class mainHomeList extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> stream;
  final String system;
  final String pondname;

  const mainHomeList(
      {super.key,
      required this.stream,
      required this.system,
      required this.pondname});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return StreamBuilder(
      stream: stream.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // data extraction
          final found = snapshot.data!
              .data()!
              .entries
              .firstWhere((element) => element.key == system)
              .value;
          if (found != null) {
            Map data = found as Map;
            // value asigning
            double PH = double.parse(data['PH'].toString());
            double TEMP = double.parse(data['TEMP'].toString());
            double DO = double.parse(data['DO'].toString());
            double TDS = double.parse(data['TDS'].toString());

            // display check
            bool PHShow = (PH > 0.0);
            bool DOShow = (DO > 0.0);
            bool TEMPShow = (TEMP > 0.0);
            bool TDSShow = (TDS > 0.0);

            double TEMPpercentage =
                double.parse(data['TEMP'].toString()) / 50.0;

            // display string
            String PHString, TEMPString, DOString;

            if (PH > 6.5 && PH <= 7.5) {
              PHString = "Neutral";
            } else if (PH > 7.5 && PH <= 8.5) {
              PHString = "Optimum";
            } else if (PH > 5.5 && PH < 6.5) {
              PHString = "Slightly acidic";
            } else if (PH <= 5.5) {
              PHString = "Acidic";
            } else if (PH > 8.5) {
              PHString = "Basic";
            } else {
              PHString = "Error";
            }

            if (TEMP >= 25 && TEMP <= 35) {
              TEMPString = "Optimum";
            } else if (TEMP > 35) {
              TEMPString = "High";
            } else if (TEMP < 25) {
              TEMPString = "Low";
            } else {
              TEMPString = "Error";
            }

            if (DO >= 5 && DO <= 11) {
              DOString = "Optimum";
            } else if (DO > 11) {
              DOString = "High";
            } else if (DO < 5) {
              DOString = "Low";
            } else {
              DOString = "";
            }
            // notification.showNotifier(id: 0, body: "hello", title: "New");
            return Expanded(
              child: isPortrait
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Visibility(
                          maintainSize: false,
                          visible: DOShow,
                          child: card1(
                            header: "oxygen level",
                            displayVal: DO,
                            sideText: "ppm",
                            footer: DOString,
                            sidewidget: Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: flask(value: DO),
                            ),
                            systemname: system,
                            pondname: pondname,
                          ),
                        ),
                        Visibility(
                          maintainSize: false,
                          visible: PHShow,
                          child: card1(
                            header: "PH level",
                            displayVal: PH,
                            sideText: "",
                            footer: PHString,
                            sidewidget: Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: phind(
                                value: double.parse(data['PH'].toString()),
                              ),
                            ),
                            systemname: system,
                            pondname: pondname,
                          ),
                        ),
                        TEMPShow && TDSShow
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  card2(
                                    header: 'temperature',
                                    sider: '°C',
                                    val: TEMP,
                                    centerWidget:
                                        linearIndicator(temp: TEMPpercentage),
                                    footer: TEMPString,
                                    systemname: system,
                                    pondname: pondname,
                                  ),
                                  card2(
                                    header: 'salanity',
                                    val: TDS,
                                    sider: 'ppt',
                                    centerWidget: circularIndicator(tds: TDS),
                                    footer: TEMPString,
                                    systemname: system,
                                    pondname: pondname,
                                  ),
                                ],
                              )
                            : TEMPShow
                                ? card1(
                                    header: "temperature",
                                    displayVal: TEMP,
                                    sideText: "°C",
                                    footer: TEMPString,
                                    sidewidget: Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.03),
                                      child:
                                          linearIndicator(temp: TEMPpercentage),
                                    ),
                                    systemname: system,
                                    pondname: pondname,
                                  )
                                : TDSShow
                                    ? card1(
                                        header: "salanity",
                                        displayVal: TDS,
                                        sideText: "ppt",
                                        footer: PHString,
                                        sidewidget: circularIndicator(tds: TDS),
                                        systemname: system,
                                        pondname: pondname,
                                      )
                                    : const SizedBox(),
                        SizedBox(
                          height: height * 0.001,
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Visibility(
                            visible: DOShow,
                            child: card2(
                              header: 'oxygen level',
                              sider: 'ppm',
                              val: DO,
                              centerWidget: flask(value: DO),
                              footer: DOString,
                              systemname: system,
                              pondname: pondname,
                            ),
                          ),
                          Visibility(
                            visible: PHShow,
                            child: card2(
                              header: 'ph level',
                              sider: '',
                              val: PH,
                              centerWidget: phind(
                                value: double.parse(data['PH'].toString()),
                              ),
                              footer: PHString,
                              systemname: system,
                              pondname: pondname,
                            ),
                          ),
                          Visibility(
                            visible: TEMPShow,
                            child: card2(
                              header: 'temperature',
                              sider: '°C',
                              val: TEMP,
                              centerWidget:
                                  linearIndicator(temp: TEMPpercentage),
                              footer: TEMPString,
                              systemname: system,
                              pondname: pondname,
                            ),
                          ),
                          Visibility(
                            visible: TDSShow,
                            child: card2(
                              header: 'salanity',
                              val: TDS,
                              sider: 'ppt',
                              centerWidget: circularIndicator(tds: TDS),
                              footer: TEMPString,
                              systemname: system,
                              pondname: pondname,
                            ),
                          )
                        ]),
            );
          } else {
            return const Center(
              child: Text("No Data Found"),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('An error occured in retreving the data'));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
