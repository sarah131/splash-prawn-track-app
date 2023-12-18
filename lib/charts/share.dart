import 'dart:io';

import 'package:share_plus/share_plus.dart';

class share {
  static Future shareFile(File file, String text) async {
    print(file.path);
    await Share.shareFiles([file.path], text: text);
  }
}
