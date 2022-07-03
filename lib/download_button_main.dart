import 'package:flutter/material.dart';

class DownloadButtonProps {
    List<int> imageInBytes;
    DownloadButtonProps({ required this.imageInBytes});
}

class DownloadButton extends StatelessWidget {

  final DownloadButtonProps data;
  const DownloadButton({Key? key, required this.data}): super(key: key);
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