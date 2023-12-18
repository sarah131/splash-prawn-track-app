// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_page/auth.dart';
import '../theme/theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = Auth().currentUser;
  bool editBool = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    phonenoController.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var Width = MediaQuery.of(context).size.width;
    var Height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool propotion = Orientation.portrait == MediaQuery.of(context).orientation;
    var scrWidth = propotion ? Width : Height;
    var scrHeight = !propotion ? Width : Height;
    final data = !themeProvider.isDark ? Colors.black : Colors.white;

    bool isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;

    return Scaffold(
      body: isPortrait
          ? SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(Auth().currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final String name = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere((element) => element.key == 'name')
                          .value;
                      final String phoneNo = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere(
                              (element) => element.key == 'phone number')
                          .value;
                      final String version = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere((element) => element.key == 'version')
                          .value;
                      final bool checkVersion =
                          version == 'lightVersion' ? false : true;
                      return Column(children: [
                        const SizedBox(
                          height: 70,
                        ),
                        const Center(
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Center(
                          child: Image(
                            image: AssetImage("images/profile1.png"),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 5),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff938D8D),
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: scrHeight / 15,
                          width: scrWidth / 1.12,
                          padding: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: data,
                          ),
                          child: Center(
                            child: TextField(
                              controller: nameController,
                              readOnly: editBool,
                              decoration: InputDecoration(
                                  hintText: name, border: InputBorder.none),
                              style: const TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 5),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff938D8D),
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: scrHeight / 15,
                          width: scrWidth / 1.12,
                          padding: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: data,
                          ),
                          child: Center(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: user?.email ?? 'User email',
                                  border: InputBorder.none),
                              style: const TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 5),
                            child: Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff938D8D),
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: scrHeight / 15,
                          width: scrWidth / 1.12,
                          padding: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: data,
                          ),
                          child: Center(
                            child: TextField(
                              controller: phonenoController,
                              readOnly: editBool,
                              decoration: InputDecoration(
                                  hintText: phoneNo, border: InputBorder.none),
                              style: const TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        !checkVersion
                            ? const SizedBox(
                                height: 18,
                              )
                            : const SizedBox(),
                        !checkVersion
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.0, bottom: 5),
                                  child: Text(
                                    "Apply Coupon",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff938D8D),
                                      fontFamily: 'SF-Pro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        !checkVersion
                            ? Container(
                                height: scrHeight / 15,
                                width: scrWidth / 1.12,
                                padding: const EdgeInsets.only(left: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: data,
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: couponController,
                                    readOnly: editBool,
                                    decoration: const InputDecoration(
                                        hintText:
                                            'Enter Coupon to Upgrade to proversion',
                                        border: InputBorder.none),
                                    style: const TextStyle(
                                      fontFamily: 'SF-Pro',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: scrHeight / 28,
                        ),
                        Container(
                          height: 41,
                          width: scrWidth / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromARGB(255, 157, 157, 180),
                          ),
                          child: MaterialButton(
                            onPressed: () => setState(() {
                              if (!editBool) {
                                nameController.text.isNotEmpty;
                              }
                              editBool = !editBool;
                            }),
                            child: Text(
                              editBool ? "Edit" : "Submit",
                              style: const TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 41,
                          width: scrWidth / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color.fromARGB(255, 157, 157, 180),
                          ),
                          child: MaterialButton(
                            onPressed: signOut,
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ]);
                    } else {
                      return const SizedBox();
                    }
                  }),
            )
          :
          //landscape mode for profile
          SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(Auth().currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final String name = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere((element) => element.key == 'name')
                          .value;
                      final String phoneNo = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere(
                              (element) => element.key == 'phone number')
                          .value;
                      final String version = snapshot.data!
                          .data()!
                          .entries
                          .firstWhere((element) => element.key == 'version')
                          .value;
                      final bool checkVersion =
                          version == 'lightVersion' ? false : true;
                      return Container(
                        margin: EdgeInsets.only(top: Height * 0.025),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  right: Width * 0.02, bottom: Height * 0.03),
                              margin: EdgeInsets.symmetric(vertical: 30),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          width: 2.0))),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: Height * 0.06, left: Width * 0.05),
                                    child: Text(
                                      "Profile",
                                      style: TextStyle(
                                        fontFamily: 'SF-Pro',
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: Width * 0.05),
                                    child: Image(
                                      image: AssetImage("images/profile1.png"),
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: Width * 0.05),
                                    height: 41,
                                    width: scrWidth / 2.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color.fromARGB(
                                          255, 157, 157, 180),
                                    ),
                                    child: MaterialButton(
                                      onPressed: () => setState(() {
                                        if (!editBool) {
                                          nameController.text.isNotEmpty;
                                        }
                                        editBool = !editBool;
                                      }),
                                      child: Text(
                                        editBool ? "Edit" : "Submit",
                                        style: const TextStyle(
                                          fontFamily: 'SF-Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: Width * 0.05),
                                    height: 41,
                                    width: scrWidth / 2.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color.fromARGB(
                                          255, 157, 157, 180),
                                    ),
                                    child: MaterialButton(
                                      onPressed: signOut,
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontFamily: 'SF-Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //input fields
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Height * 0.05,
                                      bottom: Height * 0.01,
                                      left: Width * 0.03),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff938D8D),
                                      fontFamily: 'SF-Pro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: scrHeight / 15,
                                  width: scrWidth / 0.83,
                                  margin: EdgeInsets.only(left: Width * 0.02),
                                  padding: const EdgeInsets.only(left: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: data,
                                  ),
                                  child: Center(
                                    child: TextField(
                                      controller: nameController,
                                      readOnly: editBool,
                                      decoration: InputDecoration(
                                          hintText: name,
                                          border: InputBorder.none),
                                      style: const TextStyle(
                                        fontFamily: 'SF-Pro',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: Height * 0.01,
                                      bottom: Height * 0.01,
                                      left: Width * 0.03),
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff938D8D),
                                      fontFamily: 'SF-Pro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: scrHeight / 15,
                                  width: scrWidth / 0.83,
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: EdgeInsets.only(left: Width * 0.02),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: data,
                                  ),
                                  child: Center(
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          hintText: user?.email ?? 'User email',
                                          border: InputBorder.none),
                                      style: const TextStyle(
                                        fontFamily: 'SF-Pro',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: Height * 0.01,
                                              bottom: Height * 0.01,
                                              left: Width * 0.03),
                                          child: Text(
                                            "Phone Number",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff938D8D),
                                              fontFamily: 'SF-Pro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: scrHeight / 15,
                                          width: scrWidth / 2,
                                          margin: EdgeInsets.only(
                                              left: Width * 0.02),
                                          padding:
                                              const EdgeInsets.only(left: 18),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: data,
                                          ),
                                          child: Center(
                                            child: TextField(
                                              controller: phonenoController,
                                              readOnly: editBool,
                                              decoration: InputDecoration(
                                                  hintText: phoneNo,
                                                  border: InputBorder.none),
                                              style: const TextStyle(
                                                fontFamily: 'SF-Pro',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        !checkVersion
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    top: Height * 0.01,
                                                    bottom: Height * 0.01,
                                                    left: Width * 0.03),
                                                child: Text(
                                                  "Apply Coupon",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xff938D8D),
                                                    fontFamily: 'SF-Pro',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        !checkVersion
                                            ? Container(
                                                height: scrHeight / 15,
                                                width: scrWidth / 1.5,
                                                margin: EdgeInsets.only(
                                                    left: Width * 0.02),
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: data,
                                                ),
                                                child: Center(
                                                  child: TextField(
                                                    controller:
                                                        couponController,
                                                    readOnly: editBool,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter Coupon for Premeium',
                                                            border: InputBorder
                                                                .none),
                                                    style: const TextStyle(
                                                      fontFamily: 'SF-Pro',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                                !checkVersion
                                    ? const SizedBox(
                                        height: 18,
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../login_page/auth.dart';
// import '../theme/theme.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final User? user = Auth().currentUser;
//   bool editBool = true;

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phonenoController = TextEditingController();
//   TextEditingController couponController = TextEditingController();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     nameController.dispose();
//     phonenoController.dispose();
//     couponController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var Width = MediaQuery.of(context).size.width;
//     var Height = MediaQuery.of(context).size.height;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     bool propotion = Orientation.portrait == MediaQuery.of(context).orientation;
//     var scrWidth = propotion ? Width : Height;
//     var scrHeight = !propotion ? Width : Height;
//     final data = !themeProvider.isDark ? Colors.black : Colors.white;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(Auth().currentUser!.email)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 final String name = snapshot.data!
//                     .data()!
//                     .entries
//                     .firstWhere((element) => element.key == 'name')
//                     .value;
//                 final String phoneNo = snapshot.data!
//                     .data()!
//                     .entries
//                     .firstWhere((element) => element.key == 'phone number')
//                     .value;
//                 final String version = snapshot.data!
//                     .data()!
//                     .entries
//                     .firstWhere((element) => element.key == 'version')
//                     .value;
//                 final bool checkVersion =
//                     version == 'lightVersion' ? false : true;
//                 return Column(children: [
//                   const SizedBox(
//                     height: 70,
//                   ),
//                   const Center(
//                     child: Text(
//                       "Profile",
//                       style: TextStyle(
//                         fontFamily: 'SF-Pro',
//                         fontSize: 27,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Center(
//                     child: Image(
//                       image: AssetImage("images/profile1.png"),
//                       height: 100,
//                       width: 100,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 25.0, bottom: 5),
//                       child: Text(
//                         "Name",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Color(0xff938D8D),
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: scrHeight / 15,
//                     width: scrWidth / 1.12,
//                     padding: const EdgeInsets.only(left: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       color: data,
//                     ),
//                     child: Center(
//                       child: TextField(
//                         controller: nameController,
//                         readOnly: editBool,
//                         decoration: InputDecoration(
//                             hintText: name, border: InputBorder.none),
//                         style: const TextStyle(
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 18,
//                   ),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 25.0, bottom: 5),
//                       child: Text(
//                         "Email",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Color(0xff938D8D),
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: scrHeight / 15,
//                     width: scrWidth / 1.12,
//                     padding: const EdgeInsets.only(left: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       color: data,
//                     ),
//                     child: Center(
//                       child: TextField(
//                         readOnly: true,
//                         decoration: InputDecoration(
//                             hintText: user?.email ?? 'User email',
//                             border: InputBorder.none),
//                         style: const TextStyle(
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 18,
//                   ),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 25.0, bottom: 5),
//                       child: Text(
//                         "Phone Number",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Color(0xff938D8D),
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: scrHeight / 15,
//                     width: scrWidth / 1.12,
//                     padding: const EdgeInsets.only(left: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       color: data,
//                     ),
//                     child: Center(
//                       child: TextField(
//                         controller: phonenoController,
//                         readOnly: editBool,
//                         decoration: InputDecoration(
//                             hintText: phoneNo, border: InputBorder.none),
//                         style: const TextStyle(
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   !checkVersion
//                       ? const SizedBox(
//                           height: 18,
//                         )
//                       : const SizedBox(),
//                   !checkVersion
//                       ? const Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 25.0, bottom: 5),
//                             child: Text(
//                               "Apply Coupon",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Color(0xff938D8D),
//                                 fontFamily: 'SF-Pro',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   !checkVersion
//                       ? Container(
//                           height: scrHeight / 15,
//                           width: scrWidth / 1.12,
//                           padding: const EdgeInsets.only(left: 18),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15.0),
//                             color: data,
//                           ),
//                           child: Center(
//                             child: TextField(
//                               controller: couponController,
//                               readOnly: editBool,
//                               decoration: const InputDecoration(
//                                   hintText:
//                                       'Enter Coupon to Upgrade to proversion',
//                                   border: InputBorder.none),
//                               style: const TextStyle(
//                                 fontFamily: 'SF-Pro',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                   SizedBox(
//                     height: scrHeight / 28,
//                   ),
//                   Container(
//                     height: 41,
//                     width: scrWidth / 2.5,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: const Color.fromARGB(255, 157, 157, 180),
//                     ),
//                     child: MaterialButton(
//                       onPressed: () => setState(() {
//                         if (!editBool) {
//                           nameController.text.isNotEmpty;
//                         }
//                         editBool = !editBool;
//                       }),
//                       child: Text(
//                         editBool ? "Edit" : "Submit",
//                         style: const TextStyle(
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Container(
//                     height: 41,
//                     width: scrWidth / 2.5,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: const Color.fromARGB(255, 157, 157, 180),
//                     ),
//                     child: MaterialButton(
//                       onPressed: signOut,
//                       child: const Text(
//                         "Logout",
//                         style: TextStyle(
//                           fontFamily: 'SF-Pro',
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]);
//               } else {
//                 return const SizedBox();
//               }
//             }),
//       ),
//     );
//   }

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }
