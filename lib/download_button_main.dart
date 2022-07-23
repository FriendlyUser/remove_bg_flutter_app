import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadButtonProps {
    List<int> imageInBytes;
    DownloadButtonProps({ required this.imageInBytes});
}

class DownloadButton extends StatelessWidget {

  final DownloadButtonProps data;
  const DownloadButton({Key? key, required this.data}): super(key: key);

  Future<String> getFilePath() async {
    Directory? appDocumentsDirectory; 
    try {
      appDocumentsDirectory ??= await getExternalStorageDirectory();
    } catch (e) {
      print(e);
    }
    print(appDocumentsDirectory);
    appDocumentsDirectory ??= await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    // random file name to avoid overwriting existing files.
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    String filePath = '$appDocumentsPath/$fileName';
    print(filePath);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // saveFile(uploadedImage.toString())
        {
          File file = File(await getFilePath());
          await file.writeAsBytes(data.imageInBytes);
        }
      },
      child: const Text("Save File"),
    );
  }
}