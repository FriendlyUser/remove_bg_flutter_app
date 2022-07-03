import 'package:flutter/material.dart';
import 'package:rm_img_bg/download_button.dart';


class DownloadButtonMain extends StatelessWidget {

  final DownloadButtonProps data;
  const DownloadButtonMain({Key? key, required this.data}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        // saveFile(uploadedImage.toString())
          {
            print("DO SOMETHING HERE")
          }
      },
      child: const Text("Save File"),
    );
  }
}