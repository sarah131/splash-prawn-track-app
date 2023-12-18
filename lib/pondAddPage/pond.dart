import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_1/pondAddPage/addPond.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_page/auth.dart';
import '../providers/pathProvider.dart';

class pond extends StatefulWidget {
  const pond({super.key});

  @override
  State<pond> createState() => _pondState();
}

class _pondState extends State<pond> {
  // bool expanded = false;
  String? expandedPond;
  String fixedPond = 'pond1';
  var docref = FirebaseFirestore.instance
      .collection('dataStore')
      .doc(Auth().currentUser!.email);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.transparent),
        height: height,
        width: width,
        padding: EdgeInsets.only(
            top: height * 0.02, left: width * 0.08, right: width * 0.08),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.1,
                  ),
                  Text(
                    'Pond',
                    style: TextStyle(
                        fontSize: isPortrait ? width * 0.08 : width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const addPond())),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: isPortrait ? width * 0.1 : width * 0.04,
                          color: Colors.black,
                        ),
                      ),
                      const Positioned(
                        bottom: -10,
                        left: -10,
                        child: Text(
                          'ADD POND',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 125, 125, 125),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.06,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: docref.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> allvalue = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere((element) => element.key == 'ponds')
                          .value;
                      print(allvalue);

                      var allvaluelist = allvalue.entries.toList();
                      List ponds = [];
                      for (var pond in allvaluelist) {
                        ponds.add(pond.key);
                      }
                      ponds.remove('notset');
                      print(ponds);
                      // return SizedBox();
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: ponds.length,
                        itemBuilder: (context, index) {
                          return tiles(height, width, ponds[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('NO PONDS FOUND YET, ADD SOME PONDS'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // bool expand = false;
  Widget tiles(double height, double width, String pond) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.04),
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 204, 204, 204), width: 2),
          borderRadius: BorderRadius.circular(14)),
      child: StreamBuilder(
          stream: docref.collection(pond).doc('pondDetail').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                    'Something went wrong!, No data exists. Add an Pond to view the data'),
              );
            }
            if (snapshot.hasData) {
              var coverage = snapshot.data!
                  .data()!
                  .entries
                  .firstWhere((element) => element.key == 'coverage')
                  .value;
              var systemsCount = snapshot.data!
                  .data()!
                  .entries
                  .firstWhere((element) => element.key == 'systemsCount')
                  .value;
              bool isPortrait =
                  Orientation.portrait == MediaQuery.of(context).orientation;
              return ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                collapsedBackgroundColor: Colors.white,
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.white,
                expandedAlignment: Alignment.centerLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      pond,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: isPortrait ? width * 0.055 : width * 0.03,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: height * 0.006,
                    ),
                    expandedPond == pond
                        ? const SizedBox()
                        : Container(
                            margin: isPortrait
                                ? EdgeInsets.only(bottom: height * 0.02)
                                : EdgeInsets.only(
                                    top: height * 0.02, bottom: height * 0.02),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    const Color.fromARGB(255, 211, 211, 211)),
                            child: Text(
                              'More Detail',
                              style: TextStyle(
                                  fontSize:
                                      isPortrait ? width * 0.035 : width * 0.02,
                                  color: const Color.fromARGB(255, 54, 54, 54)),
                            ),
                          ),
                  ],
                ),
                onExpansionChanged: (value) {
                  print(value);
                  setState(() {
                    value ? expandedPond = pond : expandedPond = '';
                    // expand = value;
                  });
                },
                collapsedTextColor: Colors.black,
                trailing: fixedPond != pond
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final pondProvider = Provider.of<PathProvider>(
                                context,
                                listen: false);
                            pondProvider.togglePond(pond);
                            fixedPond = pond;
                          });
                        },
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0)),
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 165, 165, 169),
                          ),
                        ),
                        child: Text(
                          'Switch',
                          style: TextStyle(
                            fontSize: isPortrait ? width * 0.04 : width * 0.02,
                          ),
                        ),
                      )
                    : Container(
                        margin: isPortrait
                            ? EdgeInsets.only(
                                top: height * 0.01, right: width * 0.04)
                            : EdgeInsets.only(
                                top: height * 0.02, right: width * 0.02),
                        child: Text(
                          'Active',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 91, 91, 91),
                              fontSize:
                                  isPortrait ? width * 0.045 : width * 0.03,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                children: [
                  element(
                    maintext: "Pond Size: ",
                    subtext: "$coverage sq ft",
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  element(
                    maintext: 'No. of systems: ',
                    subtext: systemsCount.toString(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: isPortrait
                            ? EdgeInsets.only(
                                right: width * 0.04, bottom: height * 0.01)
                            : EdgeInsets.only(
                                right: width * 0.04, bottom: height * 0.03),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 102, 102, 104),
                              fontSize:
                                  isPortrait ? width * 0.045 : width * 0.03,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}

class element extends StatelessWidget {
  final String maintext;
  final String subtext;

  const element({super.key, required this.maintext, required this.subtext});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    return Padding(
      padding: isPortrait
          ? EdgeInsets.only(left: width * 0.04)
          : EdgeInsets.only(left: width * 0.02),
      child: RichText(
        softWrap: true,
        text: TextSpan(
          children: [
            TextSpan(
                text: maintext,
                style: TextStyle(
                    color: const Color.fromARGB(255, 58, 58, 58),
                    fontWeight: FontWeight.w700,
                    fontSize: isPortrait ? width * 0.048 : width * 0.03)),
            TextSpan(
                text: subtext,
                style: TextStyle(
                    color: const Color.fromARGB(255, 141, 141, 141),
                    fontWeight: FontWeight.w600,
                    fontSize: isPortrait ? width * 0.0425 : width * 0.025)),
          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashboard_1/pondAddPage/addPond.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../login_page/auth.dart';
// import '../providers/pathProvider.dart';

// class pond extends StatefulWidget {
//   const pond({super.key});

//   @override
//   State<pond> createState() => _pondState();
// }

// class _pondState extends State<pond> {
//   // bool expanded = false;
//   String? expandedPond;
//   String fixedPond = 'pond1';
//   var docref = FirebaseFirestore.instance
//       .collection('dataStore')
//       .doc(Auth().currentUser!.email);

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12), color: Colors.transparent),
//         height: height,
//         width: width,
//         padding: EdgeInsets.only(
//             top: height * 0.02, left: width * 0.08, right: width * 0.08),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: width * 0.1,
//                   ),
//                   Text(
//                     'Pond',
//                     style: TextStyle(
//                         fontSize: width * 0.08, fontWeight: FontWeight.bold),
//                   ),
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (context) => const addPond())),
//                         padding: EdgeInsets.zero,
//                         icon: Icon(
//                           Icons.add_circle_outline,
//                           size: width * 0.1,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const Positioned(
//                         bottom: -20,
//                         left: -10,
//                         child: Text(
//                           'ADD POND',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: Color.fromARGB(255, 125, 125, 125),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: height * 0.06,
//               ),
//               Expanded(
//                 child: StreamBuilder(
//                   stream: docref.snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       Map<String, dynamic> allvalue = snapshot.data!
//                           .data()!
//                           .entries
//                           .firstWhere((element) => element.key == 'ponds')
//                           .value;

//                       var allvaluelist = allvalue.entries.toList();
//                       List ponds = [];
//                       for (var pond in allvaluelist) {
//                         ponds.add(pond.key);
//                       }
//                       ponds.remove('notset');
//                       // return SizedBox();
//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         itemCount: ponds.length,
//                         itemBuilder: (context, index) {
//                           return tiles(height, width, ponds[index]);
//                         },
//                       );
//                     } else {
//                       return const Center(
//                         child: Text('NO PONDS FOUND YET, ADD SOME PONDS'),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // bool expand = false;
//   Widget tiles(double height, double width, String pond) {
//     return Container(
//       margin: EdgeInsets.only(bottom: height * 0.04),
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: const Color.fromARGB(255, 204, 204, 204), width: 2),
//           borderRadius: BorderRadius.circular(14)),
//       child: StreamBuilder(
//           stream: docref.collection(pond).doc('pondDetail').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                     'Something went wrong!, No data exists. Add an Pond to view the data'),
//               );
//             }
//             if (snapshot.hasData) {
//               var coverage = snapshot.data!
//                   .data()!
//                   .entries
//                   .firstWhere((element) => element.key == 'coverage')
//                   .value;
//               var systemsCount = snapshot.data!
//                   .data()!
//                   .entries
//                   .firstWhere((element) => element.key == 'systemsCount')
//                   .value;
//               return ExpansionTile(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 collapsedBackgroundColor: Colors.white,
//                 collapsedShape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 backgroundColor: Colors.white,
//                 expandedAlignment: Alignment.centerLeft,
//                 expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: height * 0.01,
//                     ),
//                     Text(
//                       pond,
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: width * 0.055,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(
//                       height: height * 0.006,
//                     ),
//                     expandedPond == pond
//                         ? const SizedBox()
//                         : Container(
//                             margin: EdgeInsets.only(bottom: height * 0.01),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color:
//                                     const Color.fromARGB(255, 211, 211, 211)),
//                             child: Text(
//                               'More Detail',
//                               style: TextStyle(
//                                   fontSize: width * 0.035,
//                                   color: const Color.fromARGB(255, 54, 54, 54)),
//                             ),
//                           ),
//                   ],
//                 ),
//                 onExpansionChanged: (value) {
//                   setState(() {
//                     value ? expandedPond = pond : expandedPond = '';
//                     // expand = value;
//                   });
//                 },
//                 collapsedTextColor: Colors.black,
//                 trailing: fixedPond != pond
//                     ? ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             final pondProvider = Provider.of<PathProvider>(
//                                 context,
//                                 listen: false);
//                             pondProvider.togglePond(pond);
//                             fixedPond = pond;
//                           });
//                         },
//                         style: const ButtonStyle(
//                           padding: MaterialStatePropertyAll(
//                               EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 0)),
//                           backgroundColor: MaterialStatePropertyAll(
//                             Color.fromARGB(255, 165, 165, 169),
//                           ),
//                         ),
//                         child: Text(
//                           'Switch',
//                           style: TextStyle(
//                             fontSize: width * 0.04,
//                           ),
//                         ),
//                       )
//                     : Container(
//                         margin: EdgeInsets.only(
//                             top: height * 0.01, right: width * 0.04),
//                         child: Text(
//                           'Active',
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 91, 91, 91),
//                               fontSize: width * 0.045,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                 children: [
//                   element(
//                     maintext: "Pond Size: ",
//                     subtext: "$coverage sq ft",
//                   ),
//                   SizedBox(
//                     height: height * 0.01,
//                   ),
//                   element(
//                     maintext: 'No. of systems: ',
//                     subtext: systemsCount.toString(),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         margin: EdgeInsets.only(
//                             right: width * 0.04, bottom: height * 0.01),
//                         child: Text(
//                           'Edit',
//                           style: TextStyle(
//                               color: const Color.fromARGB(255, 102, 102, 104),
//                               fontSize: width * 0.045,
//                               fontWeight: FontWeight.w800),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             } else {
//               return const SizedBox();
//             }
//           }),
//     );
//   }
// }

// class element extends StatelessWidget {
//   final String maintext;
//   final String subtext;

//   const element({super.key, required this.maintext, required this.subtext});

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: EdgeInsets.only(left: width * 0.04),
//       child: RichText(
//         softWrap: true,
//         text: TextSpan(
//           children: [
//             TextSpan(
//                 text: maintext,
//                 style: TextStyle(
//                     color: const Color.fromARGB(255, 58, 58, 58),
//                     fontWeight: FontWeight.w700,
//                     fontSize: width * 0.048)),
//             TextSpan(
//                 text: subtext,
//                 style: TextStyle(
//                     color: const Color.fromARGB(255, 141, 141, 141),
//                     fontWeight: FontWeight.w600,
//                     fontSize: width * 0.0425)),
//           ],
//         ),
//       ),
//     );
//   }
// }
