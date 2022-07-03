import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rm_img_bg/download_button_web.dart';
import 'package:rm_img_bg/download_button_main.dart';


class DownloadButtonProps {
  List<int> imageInBytes;
  DownloadButtonProps({ required this.imageInBytes});
}

class DownloadButton extends StatelessWidget {

  final DownloadButtonProps data;
  const DownloadButton({Key? key, required this.data}): super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return DownloadButtonWeb(data: data);
    } else {
      return DownloadButtonMain(data: data);
    }
  }
}