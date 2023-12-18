import 'package:open_file_plus/open_file_plus.dart';

class open {
  static Future openFile(String path) async {
    final message = await OpenFile.open(path);
    print(message.message);
  }
}
