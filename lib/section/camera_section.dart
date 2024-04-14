import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hans/service/state_service.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  /*
  runApp(
    MaterialApp(
      home: TakePic(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
  */
}

class TakePic extends StatefulWidget {
  const TakePic({super.key,
                required this.camera,
                required this.setAppState});

  final CameraDescription camera;
  final Function(AppState appState) setAppState;

  @override
  State<TakePic> createState() => _TakePicState();
}

class _TakePicState extends State<TakePic> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState(){
    _controller = CameraController(
      const CameraDescription(
        sensorOrientation: 1,
        name: '0',
        lensDirection: CameraLensDirection.back,
      ),
      ResolutionPreset.medium,
      );
    super.initState();
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  //* UI *//
  @override
  void _openPopUpSharePic(){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          scrollable: false,
          title: const Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: [
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(getAsset("tmp/tmp.png")),
                      fit: BoxFit.cover
                      ),
                    )
                  ),
                ],
              ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                // Send them to your email maybe?
                //var email = emailController.text;
                //var message = messageController.text;
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==ConnectionState.done) {
            return CameraPreview(_controller);
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.black,
        ),
        onPressed: () async {
          try {
            final image = _controller.takePicture();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewState(imagePath: image.path)));
          } catch (e) {};
        },
      ),
    );
  }
}

class PreviewState extends StatefulWidget {
  const PreviewState({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<PreviewState> createState() => _PreviewStateState();
}

class _PreviewStateState extends State<PreviewState> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}