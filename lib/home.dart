import 'package:dashboard_1/navigator/gnav.dart';
import 'package:flutter/material.dart';

// import 'base.dart';
import 'login_page/login_register_page.dart';
import 'login_page/auth.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const gnav();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
