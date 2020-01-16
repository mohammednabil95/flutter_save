import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtil{

  String fileName;


  FileUtil(this.fileName);

  Future<String> getDirectory() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getFile() async {
    final path = await getDirectory();
    return File('$path/' + fileName);
  }

  Future<String> readFile() async {
    try {
      final file = await getFile();
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<File> writeToFile(String content)  async {
    final file = await getFile();
    return file.writeAsString(content);

  }

}