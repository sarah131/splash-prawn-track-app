import 'dart:io';

import 'package:path_provider/path_provider.dart';

class save {
  static Future saveStringFile(
      {required String filename, required String bytes}) async {
    final directoryPath = await getApplicationDocumentsDirectory();
    final path = "${directoryPath.path}$filename.csv";
    final File file = File(path);
    await file.writeAsString(bytes);

    return file;
  }
}
