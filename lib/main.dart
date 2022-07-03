import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:html' as _html;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  // return Image object of whatever is returned from the bg.remove api
  uploadImage(XFile image) async {
    var formData = FormData();
    var dio = Dio();
    // flutter add api token
    // hardcoded free access token
    dio.options.headers["X-Api-Key"] = "FJHgW6w97C48efycXaUYcHkU";
    try {
      if (kIsWeb) {
        var _bytes = await image.readAsBytes();
        formData.files.add(MapEntry(
          "image_file",
          MultipartFile.fromBytes(_bytes, filename: "pic-name.png"),
        ));
      } else {
        formData.files.add(MapEntry(
          "image_file",
          await MultipartFile.fromFile(image.path, filename: "pic-name.png"),
        ));
      }
      Response<List<int>> response = await dio.post(
          "https://api.remove.bg/v1.0/removebg",
          data: formData,
          options: Options(responseType: ResponseType.bytes));
      return response.data;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            final uploadedImageResp = await uploadImage(image);
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                    uploadedImage: uploadedImageResp),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final List<int> uploadedImage;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.uploadedImage});

  @override
  Widget build(BuildContext context) {
    var image;
    if (kIsWeb) {
      image = Image.network(imagePath);
    } else {
      image = Image.file(File(imagePath));
    }
    // var otherImage = Image.memory (uploadedImage);
    var otherImage = null;
    try {
      otherImage = Image.memory(Uint8List.fromList(uploadedImage));
    } catch (e) {
      otherImage = SizedBox.shrink();
    }
    var imageData = otherImage.toString();
    var downloadButton = null;
    String base64String = base64Encode(Uint8List.fromList(uploadedImage));
    String header = "data:image/png;base64";
    downloadButton = ElevatedButton(
      onPressed: () => {
        // saveFile(uploadedImage.toString())
          {
            downloadButton = _html.AnchorElement(
                href:
                    "$header,$base64String")
              ..setAttribute("download", "file.png")
              ..click()
          }
      },
      child: Text("Save File"),
    );
    downloadButton ??= const SizedBox.shrink();
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
            child: Row(children: [
          Column(children: [
            Text("Original Image"),
            image,
          ]),
          Column(children: [
            Text("Background Removed Image"),
            otherImage,
            downloadButton,
          ]),
        ])));
  }
}
