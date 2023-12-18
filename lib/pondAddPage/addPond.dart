import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_1/login_page/auth.dart';
import 'package:location/location.dart';

import '/helper/back.dart';
import 'package:flutter/material.dart';

class addPond extends StatefulWidget {
  const addPond({super.key});

  @override
  State<addPond> createState() => _addPondState();
}

class _addPondState extends State<addPond> {
  TextEditingController nameController = TextEditingController();

  TextEditingController coverageController = TextEditingController();

  LocationData? location;

  String SelectedSystem = '';

  Future getlocation() async {
    var isServiceEnabled = await Location().serviceEnabled();
    var isPermission = await Location().hasPermission();
    if (!isServiceEnabled) {
      isServiceEnabled = await Location().requestService();
    } else {
      if (isPermission == PermissionStatus.denied) {
        isPermission = await Location().requestPermission();
      } else if (isPermission == PermissionStatus.granted) {
        location = await Location().getLocation();
        print(location);
      }
    }
  }

  Future addPondFunction() async {
    var pondname = nameController.text;
    var area = coverageController.text;
    if (pondname.isNotEmpty && area.isNotEmpty && SelectedSystem.isNotEmpty) {
      var doc = FirebaseFirestore.instance
          .collection('dataStore')
          .doc(Auth().currentUser!.email);
      var docref = await doc.get();
      bool check = false;
      Map<String, dynamic> items = docref
          .data()!
          .entries
          .firstWhere((element) => element.key == "ponds")
          .value;
      List itemList = items.entries.toList();
      for (var i in itemList) {
        if (i.key.toString() == nameController.text.trim()) {
          check = true;
          break;
        }
      }
      if (!check) {
        await doc.collection(pondname.trim()).doc('pondDetail').set({
          'coverage': coverageController.text.trim(),
          "systemsCount": 1,
          "location": "location"
        });
        await doc.collection(pondname).doc(SelectedSystem).set({});
        List notset = items['notset'];
        notset.remove(SelectedSystem);
        doc.set({
          'ponds': {
            pondname: [SelectedSystem],
            'notset': notset
          },
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 500),
            content: Center(
              child: Text('Pond Added sucessfuly'),
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 700), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 500),
            content: Center(
              child: Text('The entered pond name already exists'),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 300),
          content: Center(
            child: Text('Kindly fill all the details'),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    coverageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            left: width * 0.04, right: width * 0.04, top: height * 0.02),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                back(
                  width: isPortrait ? width : width,
                  text: 'Pond',
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Add Pond',
                    style: TextStyle(
                        fontSize: isPortrait ? width * 0.08 : width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                header(name: 'Pond Name', height: height, width: width),
                customTextField(
                    controller: nameController,
                    height: height,
                    width: width,
                    hintText: 'Enter the pond name',
                    inputType: TextInputType.text),
                header(name: 'Pond Area', height: height, width: width),
                customTextField(
                    controller: coverageController,
                    height: height,
                    width: width,
                    hintText: "Enter the pond's coverage",
                    inputType: TextInputType.number),
                header(name: 'Avaiable systems', height: height, width: width),
                availableSystemShow(height, width),
                header(
                    name: 'Selected systems details',
                    height: height,
                    width: width),
                SelectedSystem.isNotEmpty
                    ? selectedSystemDeail(width, height)
                    : const SizedBox(),
                SizedBox(
                  height: height * 0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    autofocus: true,
                    onPressed: getlocation,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 149, 149, 149))),
                    child: Text(
                      'Fetch the Location',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isPortrait ? width * 0.0425 : width * 0.03,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    autofocus: true,
                    onPressed: addPondFunction,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 108, 108, 108))),
                    child: Text(
                      'ADD POND',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isPortrait ? width * 0.0425 : width * 0.028,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toshow(
    value,
    header,
    width,
  ) {
    return value.toString() != '0'
        ? showsensordata(
            width,
            header,
            value,
          )
        : const SizedBox();
  }

  Widget selectedSystemDeail(double width, double height) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('dataStore')
            .doc(Auth().currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!
                .data()!
                .entries
                .any((element) => element.key == SelectedSystem)) {
              Map systemdata = snapshot.data!
                  .data()!
                  .entries
                  .firstWhere((element) => element.key == SelectedSystem)
                  .value;
              return Container(
                margin: EdgeInsets.only(
                    left: width * 0.06,
                    right: width * 0.06,
                    top: height * 0.01),
                padding:
                    EdgeInsets.only(left: width * 0.05, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Column(
                  children: [
                    toshow(double.parse(systemdata["PH"]), "PH VALUE: ", width),
                    const SizedBox(
                      height: 10,
                    ),
                    toshow(double.parse(systemdata["DO"]), "DO VALUE: ", width),
                    const SizedBox(
                      height: 10,
                    ),
                    toshow(double.parse(systemdata["TEMP"]),
                        "TEMPERATURE VALUE: ", width),
                    const SizedBox(
                      height: 10,
                    ),
                    toshow(double.parse(systemdata["TDS"]), "SALANITY VALUE: ",
                        width)
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("This System has no data"),
              );
            }
          } else {
            return const SizedBox();
          }
        });
  }

  Row showsensordata(double width, String header, num data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          header,
          style: TextStyle(
              color: const Color.fromARGB(255, 128, 128, 128),
              fontWeight: FontWeight.w600,
              fontSize: width * 0.04),
        ),
        Text(
          data.toString(),
          style: TextStyle(
              color: const Color.fromARGB(255, 58, 58, 58),
              fontWeight: FontWeight.w800,
              fontSize: width * 0.0425),
        )
      ],
    );
  }

  Widget availableSystemShow(double height, double width) {
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('dataStore')
            .doc(Auth().currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> alldata = snapshot.data!
                .data()!
                .entries
                .firstWhere((element) => element.key == 'ponds')
                .value;
            List availableSystem = alldata.entries
                .firstWhere((element) => element.key == 'notset')
                .value;
            return SizedBox(
              height: isPortrait ? height * 0.045 : height * 0.08,
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: isPortrait
                    ? EdgeInsets.symmetric(
                        horizontal: width * 0.06,
                      )
                    : EdgeInsets.symmetric(horizontal: width * 0.03),
                itemCount: availableSystem.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => setState(() {
                    SelectedSystem = availableSystem[index];
                    print(SelectedSystem);
                  }),
                  child: Container(
                    margin: EdgeInsets.only(right: width * 0.02),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: SelectedSystem == availableSystem[index]
                            ? [
                                const Color.fromARGB(255, 106, 188, 255),
                                const Color.fromARGB(255, 131, 139, 252),
                                const Color.fromARGB(255, 179, 128, 255)
                              ]
                            : [
                                const Color.fromARGB(255, 134, 134, 134),
                                const Color.fromARGB(255, 103, 103, 103),
                                const Color.fromARGB(255, 66, 66, 66)
                              ],
                      ),
                    ),
                    child: Text(
                      availableSystem[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isPortrait ? width * 0.04 : width * 0.02,
                          color: const Color.fromARGB(255, 249, 250, 254)),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Padding header(
      {required String name, required double height, required double width}) {
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return Padding(
      padding: EdgeInsets.only(left: 25.0, bottom: 8, top: height * 0.025),
      child: Text(
        name,
        style: TextStyle(
          fontSize: isPortrait ? width * 0.045 : width * 0.03,
          color: const Color.fromARGB(255, 108, 107, 110),
          fontFamily: 'SF-Pro',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  customTextField(
      {required double height,
      required double width,
      required String hintText,
      required TextEditingController controller,
      required TextInputType inputType}) {
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return Container(
      margin: isPortrait
          ? EdgeInsets.only(left: width * 0.05)
          : EdgeInsets.only(left: width * 0.03),
      height: isPortrait ? height * 0.05 : height * 0.12,
      width: width * 0.8,
      padding: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Center(
        child: TextField(
          keyboardType: inputType,
          controller: controller,
          decoration:
              InputDecoration(hintText: hintText, border: InputBorder.none),
          style: const TextStyle(
            fontFamily: 'SF-Pro',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashboard_1/login_page/auth.dart';
// import 'package:location/location.dart';

// import '/helper/back.dart';
// import 'package:flutter/material.dart';

// class addPond extends StatefulWidget {
//   const addPond({super.key});

//   @override
//   State<addPond> createState() => _addPondState();
// }

// class _addPondState extends State<addPond> {
//   TextEditingController nameController = TextEditingController();

//   TextEditingController coverageController = TextEditingController();

//   LocationData? location;

//   String SelectedSystem = '';

//   Future getlocation() async {
//     var isServiceEnabled = await Location().serviceEnabled();
//     var isPermission = await Location().hasPermission();
//     if (!isServiceEnabled) {
//       isServiceEnabled = await Location().requestService();
//     } else {
//       if (isPermission == PermissionStatus.denied) {
//         isPermission = await Location().requestPermission();
//       } else if (isPermission == PermissionStatus.granted) {
//         location = await Location().getLocation();
//         print(location);
//       }
//     }
//   }

//   Future addPondFunction() async {
//     var pondname = nameController.text;
//     var area = coverageController.text;
//     if (pondname.isNotEmpty && area.isNotEmpty && SelectedSystem.isNotEmpty) {
//       var doc = FirebaseFirestore.instance
//           .collection('dataStore')
//           .doc(Auth().currentUser!.email);
//       var docref = await doc.get();
//       bool check = false;
//       Map<String, dynamic> items = docref
//           .data()!
//           .entries
//           .firstWhere((element) => element.key == "ponds")
//           .value;
//       List itemList = items.entries.toList();
//       for (var i in itemList) {
//         if (i.key.toString() == nameController.text.trim()) {
//           check = true;
//           break;
//         }
//       }
//       if (!check) {
//         await doc.collection(pondname.trim()).doc('pondDetail').set({
//           'coverage': coverageController.text.trim(),
//           "systemsCount": 1,
//           "location": "location"
//         });
//         await doc.collection(pondname).doc(SelectedSystem).set({});
//         List notset = items['notset'];
//         notset.remove(SelectedSystem);
//         doc.set({
//           'ponds': {
//             pondname: [SelectedSystem],
//             'notset': notset
//           },
//         }, SetOptions(merge: true));

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             duration: Duration(milliseconds: 500),
//             content: Center(
//               child: Text('Pond Added sucessfuly'),
//             ),
//           ),
//         );
//         Future.delayed(const Duration(milliseconds: 700), () {
//           Navigator.pop(context);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             duration: Duration(milliseconds: 500),
//             content: Center(
//               child: Text('The entered pond name already exists'),
//             ),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           duration: Duration(milliseconds: 300),
//           content: Center(
//             child: Text('Kindly fill all the details'),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     nameController.dispose();
//     coverageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(
//             left: width * 0.04, right: width * 0.04, top: height * 0.02),
//         child: SingleChildScrollView(
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: height * 0.01,
//                 ),
//                 back(
//                   text: 'Pond',
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Add Pond',
//                     style: TextStyle(
//                         fontSize: width * 0.08, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 header(name: 'Pond Name', height: height, width: width),
//                 customTextField(
//                     controller: nameController,
//                     height: height,
//                     width: width,
//                     hintText: 'Enter the pond name',
//                     inputType: TextInputType.text),
//                 header(name: 'Pond Area', height: height, width: width),
//                 customTextField(
//                     controller: coverageController,
//                     height: height,
//                     width: width,
//                     hintText: "Enter the pond's coverage",
//                     inputType: TextInputType.number),
//                 header(name: 'Avaiable systems', height: height, width: width),
//                 availableSystemShow(height, width),
//                 header(
//                     name: 'Selected systems details',
//                     height: height,
//                     width: width),
//                 SelectedSystem.isNotEmpty
//                     ? selectedSystemDeail(width, height)
//                     : const SizedBox(),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: ElevatedButton(
//                     autofocus: true,
//                     onPressed: getlocation,
//                     style: const ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                             Color.fromARGB(255, 149, 149, 149))),
//                     child: Text(
//                       'Fetch the Location',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: width * 0.0425,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.03,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: ElevatedButton(
//                     autofocus: true,
//                     onPressed: addPondFunction,
//                     style: const ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                             Color.fromARGB(255, 108, 108, 108))),
//                     child: Text(
//                       'ADD POND',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: width * 0.0425,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   toshow(
//     value,
//     header,
//     width,
//   ) {
//     return value.toString() != '0'
//         ? showsensordata(
//             width,
//             header,
//             value,
//           )
//         : const SizedBox();
//   }

//   Widget selectedSystemDeail(double width, double height) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('dataStore')
//             .doc(Auth().currentUser!.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data!
//                 .data()!
//                 .entries
//                 .any((element) => element.key == SelectedSystem)) {
//               Map systemdata = snapshot.data!
//                   .data()!
//                   .entries
//                   .firstWhere((element) => element.key == SelectedSystem)
//                   .value;
//               return Container(
//                 margin: EdgeInsets.only(
//                     left: width * 0.06,
//                     right: width * 0.06,
//                     top: height * 0.01),
//                 padding:
//                     EdgeInsets.only(left: width * 0.05, top: 10, bottom: 10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.white),
//                 child: Column(
//                   children: [
//                     toshow(double.parse(systemdata["PH"]), "PH VALUE: ", width),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     toshow(double.parse(systemdata["DO"]), "DO VALUE: ", width),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     toshow(double.parse(systemdata["TEMP"]),
//                         "TEMPERATURE VALUE: ", width),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     toshow(double.parse(systemdata["TDS"]), "SALANITY VALUE: ",
//                         width)
//                   ],
//                 ),
//               );
//             } else {
//               return const Center(
//                 child: Text("This System has no data"),
//               );
//             }
//           } else {
//             return const SizedBox();
//           }
//         });
//   }

//   Row showsensordata(double width, String header, num data) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           header,
//           style: TextStyle(
//               color: const Color.fromARGB(255, 128, 128, 128),
//               fontWeight: FontWeight.w600,
//               fontSize: width * 0.04),
//         ),
//         Text(
//           data.toString(),
//           style: TextStyle(
//               color: const Color.fromARGB(255, 58, 58, 58),
//               fontWeight: FontWeight.w800,
//               fontSize: width * 0.0425),
//         )
//       ],
//     );
//   }

//   Widget availableSystemShow(double height, double width) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('dataStore')
//             .doc(Auth().currentUser!.email)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             Map<String, dynamic> alldata = snapshot.data!
//                 .data()!
//                 .entries
//                 .firstWhere((element) => element.key == 'ponds')
//                 .value;
//             List availableSystem = alldata.entries
//                 .firstWhere((element) => element.key == 'notset')
//                 .value;
//             return SizedBox(
//               height: height * 0.045,
//               width: width,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: width * 0.06,
//                 ),
//                 itemCount: availableSystem.length,
//                 itemBuilder: (context, index) => GestureDetector(
//                   onTap: () => setState(() {
//                     SelectedSystem = availableSystem[index];
//                     print(SelectedSystem);
//                   }),
//                   child: Container(
//                     margin: EdgeInsets.only(right: width * 0.02),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: SelectedSystem == availableSystem[index]
//                             ? [
//                                 const Color.fromARGB(255, 106, 188, 255),
//                                 const Color.fromARGB(255, 131, 139, 252),
//                                 const Color.fromARGB(255, 179, 128, 255)
//                               ]
//                             : [
//                                 const Color.fromARGB(255, 134, 134, 134),
//                                 const Color.fromARGB(255, 103, 103, 103),
//                                 const Color.fromARGB(255, 66, 66, 66)
//                               ],
//                       ),
//                     ),
//                     child: Text(
//                       availableSystem[index],
//                       style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: width * 0.04,
//                           color: const Color.fromARGB(255, 249, 250, 254)),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const SizedBox();
//           }
//         });
//   }

//   Padding header(
//       {required String name, required double height, required double width}) {
//     return Padding(
//       padding: EdgeInsets.only(left: 25.0, bottom: 8, top: height * 0.025),
//       child: Text(
//         name,
//         style: TextStyle(
//           fontSize: width * 0.045,
//           color: const Color.fromARGB(255, 108, 107, 110),
//           fontFamily: 'SF-Pro',
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Center customTextField(
//       {required double height,
//       required double width,
//       required String hintText,
//       required TextEditingController controller,
//       required TextInputType inputType}) {
//     return Center(
//       child: Container(
//         height: height * 0.05,
//         width: width * 0.8,
//         padding: const EdgeInsets.only(left: 18),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15.0),
//           color: Colors.white,
//         ),
//         child: TextField(
//           keyboardType: inputType,
//           controller: controller,
//           decoration:
//               InputDecoration(hintText: hintText, border: InputBorder.none),
//           style: const TextStyle(
//             fontFamily: 'SF-Pro',
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
