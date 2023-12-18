import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_1/login_page/auth.dart';
import 'package:flutter/material.dart';

class PathProvider extends ChangeNotifier {
  String pond = 'pond1';
  List systems = ['system1'];
  String? email = Auth().currentUser!.email;

  void togglePond(String newpond) {
    pond = newpond;
    notifyListeners();
    findSystems();
  }

  findSystems() async {
    var ref = await FirebaseFirestore.instance
        .collection('dataStore')
        .doc(email)
        .get();
    Map<String, dynamic> fullset =
        await ref.data()!.entries.firstWhere((e) => e.key == 'ponds').value;
    systems = fullset.isEmpty ? [] : fullset[pond]!;
    print(systems);
    notifyListeners();
  }
}
