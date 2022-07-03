import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:html' as _html;
import 'dart:typed_data';


class DownloadButtonProps {
    List<int> imageInBytes;
    DownloadButtonProps({ required this.imageInBytes});
  }

class DownloadButton extends StatelessWidget {

  final DownloadButtonProps data;
  const DownloadButton({Key? key, required this.data}): super(key: key);
  @override
  Widget build(BuildContext context) {
    String base64String = base64Encode(Uint8List.fromList(data.imageInBytes));
    String header = "data:image/png;base64"; 
    return ElevatedButton(
      onPressed: () => {
        // saveFile(uploadedImage.toString())
          {
            _html.AnchorElement(
              href:
                  "$header,$base64String")
            ..setAttribute("download", "file.png")
            ..click()
          }
      },
      child: const Text("Save File"),
    );
  }
}