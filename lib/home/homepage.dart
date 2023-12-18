import 'package:dashboard_1/login_page/auth.dart';
import 'package:dashboard_1/providers/pathProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper/cloudWidget.dart';
import 'helper/wisherWidget.dart';
import 'widget/home.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  var show = false;
  int whC = 30;
  var whS = "Mostly Cloudy";
  DocumentReference cloudFirestoreref = FirebaseFirestore.instance
      .collection('dataStore')
      .doc(Auth().currentUser!.email);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
  }

  Future<void> getWeather() async {
    var cityName = "Chennai";
    var response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=e5f0de7f89494da8b3a90715232401&q=$cityName&aqi=yes'));

    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      whC = jsonData['current']['temp_c'].toInt();
      whS = jsonData['current']["condition"]['text'];
    } else {
      whC = 28;
      whS = "Mostly Cloudy";
    }
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pond = Provider.of<PathProvider>(context);
    var pondname = pond.pond;
    var systems = pond.systems;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    double leftRightPadding = width * (isPortrait ? 0.08 : 0.04);
    double bodyFontSize = width * (isPortrait ? 0.05 : 0.03);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              top: height * 0.01,
              left: leftRightPadding,
              right: leftRightPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      wisherWidget(),
                      SizedBox(
                        height: isPortrait ? 12 : 6,
                      ),
                      RepaintBoundary(
                        child: systems.isEmpty
                            ? const Center(
                                child: Text('Systems Not found'),
                              )
                            : systemsWidget(
                                height, width, pondname, systems, isPortrait),
                      ),
                    ],
                  ),
                  cloudWidget(tempString: whS, temperature: whC),
                ],
              ),
              systems.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                            'Kindly add system to you pond! No systems are found yet!',
                            style: TextStyle(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w700)),
                      ),
                    )
                  : mainHomeList(
                      stream: FirebaseFirestore.instance
                          .collection('dataStore')
                          .doc(Auth().currentUser!.email),
                      system: systems[index],
                      pondname: pondname,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropdown(String name, Widget icon, double width, double fontSize) {
    return Container(
      padding: const EdgeInsets.only(left: 2, right: 12, top: 6, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color.fromARGB(182, 255, 255, 255)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(name,
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize)),
          ),
          const SizedBox(
            width: 12,
          ),
          icon
        ],
      ),
    );
  }

  Widget systemsWidget(double height, double width, String pondname,
      List systems, bool isPortrait) {
    double boxHeight = height * (isPortrait ? 0.05 : 0.08);
    double boxWidth = width * (isPortrait ? 0.3 : 0.185);
    double fontSize = width * (isPortrait ? 0.0425 : 0.0265);
    double itemExtend = height * (isPortrait ? 0.0325 : 0.065);
    return !show
        ? GestureDetector(
            onTap: () => setState(
              () {
                show = !show;
                index = 0;
              },
            ),
            child: dropdown(
                systems[index],
                const Image(
                  image: AssetImage("images/Icon.png"),
                ),
                width,
                fontSize),
          )
        : Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  show = !show;
                }),
                icon: const Icon(
                  Icons.thumb_up_alt_rounded,
                  shadows: [BoxShadow(color: Colors.black, blurRadius: 8)],
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                height: boxHeight,
                width: boxWidth,
                child: ListWheelScrollView(
                    itemExtent: itemExtend,
                    perspective: 0.009,
                    diameterRatio: 1.6,
                    physics: const FixedExtentScrollPhysics(),
                    restorationId: index.toString(),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    children: systems
                        .map<Widget>(
                          (e) => Text(
                            e,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize),
                          ),
                        )
                        .toList()),
              ),
            ],
          );
  }
}
