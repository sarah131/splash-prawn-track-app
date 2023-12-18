import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../home/homepage.dart';
import '../pondAddPage/pond.dart';
import '../profile/profile.dart';
import '../settings/setting.dart';
import '../theme/theme.dart';

class gnav extends StatefulWidget {
  const gnav({super.key});

  @override
  State<gnav> createState() => _gnavState();
}

class _gnavState extends State<gnav> with TickerProviderStateMixin {
  final task = [
    const Profile(),
    const pond(),
    const home(),
    const setting(),
  ];
  late int index = 2;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final theme = Provider.of<ThemeProvider>(context).isDark;
    final iconcolor = !Provider.of<ThemeProvider>(context).isDark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      bottomNavigationBar: Container(
        color: !theme ? const Color.fromARGB(255, 24, 24, 24) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: height * 0.06, vertical: 8),
        child: GNav(
          onTabChange: (value) => setState(() {
            index = value;
          }),
          selectedIndex: index,
          color: Colors.black,
          activeColor: Colors.black,
          tabBackgroundColor:
              theme ? const Color(0xffDADEEC) : const Color.fromARGB(255, 59, 59, 59),
          padding: const EdgeInsets.all(5),
          gap: 5,
          duration: const Duration(milliseconds: 600),
          tabs: [
            GButton(
              icon: Icons.account_circle,
              text: 'Profile',
              iconSize: 28,
              iconColor: iconcolor,
              iconActiveColor: iconcolor,
              textColor: iconcolor,
            ),
            GButton(
              icon: Icons.attractions_outlined,
              text: 'POND',
              iconSize: 28,
              iconColor: iconcolor,
              iconActiveColor: iconcolor,
              textColor: iconcolor,
            ),
            GButton(
              icon: Icons.home,
              text: 'Home',
              iconSize: 28,
              iconColor: iconcolor,
              iconActiveColor: iconcolor,
              textColor: iconcolor,
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              iconSize: 28,
              iconColor: iconcolor,
              iconActiveColor: iconcolor,
              textColor: iconcolor,
            ),
          ],
        ),
      ),
      body: IndexedStack(index: index, children: task),
    );
  }
}
