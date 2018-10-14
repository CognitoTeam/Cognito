import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
class TermStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/terms.txt');
  }

  Future<String> readJSON() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return e.toString();
    }
  }

  Future<File> writeJSON(String jsonString) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonString);
  }
}