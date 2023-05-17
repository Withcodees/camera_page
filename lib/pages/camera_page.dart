import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:blur/blur.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cams});

  final List<CameraDescription> cams;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();

    //Kamerayı oluşturma
    _controller = CameraController(widget.cams[1], ResolutionPreset.max);
    _controller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            showDialog(
                context: context,
                builder: (context) => const CustomErrorDialog(
                    message: "Lütfen kamera iznini verdiğinizden emin olun!"));
            break;
          default:
            showDialog(
                context: context,
                builder: (context) => const CustomErrorDialog(
                    message:
                        "İstenmedik bir hatayla karşılaşıldı.Lütfen tekrar deneyiniz!"));
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          borderRadius: _BorderRadiusManager.buttonBorderRadius,
          onTap: () {},
          child: Stack(alignment: Alignment.center, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: _BorderRadiusManager.buttonBorderRadius,
                boxShadow: const [BoxShadow(blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: _BorderRadiusManager.buttonBorderRadius,
                child: Blur(
                  blur: 7,
                  blurColor: Colors.grey.withOpacity(0.1),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: _BorderRadiusManager.buttonBorderRadius,
                          border: Border.all(width: 3, color: Colors.white)),
                      height: 100,
                      width: 300,
                      child: ClipRRect(
                        borderRadius: _BorderRadiusManager.buttonBorderRadius,
                        child: ClipRect(
                            child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: SizedBox(
                              height: _controller!.value.previewSize?.height,
                              width: _controller!.value.previewSize?.width,
                              child: CameraPreview(_controller!),
                            ),
                          ),
                        )),
                      )),
                ),
              ),
            ),
            const Text(
              "Button",
              style: TextStyle(fontSize: 30),
            ),
          ]),
        ),
      ),
    );
  }
}

class CustomErrorDialog extends StatelessWidget {
  const CustomErrorDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Center(
        child: Column(
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Tamam",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BorderRadiusManager {
  static final BorderRadius buttonBorderRadius = BorderRadius.circular(32);
}
