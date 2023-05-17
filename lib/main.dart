import 'package:cam_button/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Kamera izni iste
  await Permission.camera.request();

  runApp(MainApp(cams: await availableCameras()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.cams});

  final List<CameraDescription> cams;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(cams: cams),
    );
  }
}
