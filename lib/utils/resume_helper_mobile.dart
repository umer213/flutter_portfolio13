import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';

Future<void> downloadResume(String assetPath) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/resume.pdf');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    await OpenFile.open(file.path);
  } catch (e) {
    throw Exception('Could not download resume: $e');
  }
}
