import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:play_video/databse/database_initialize.dart';
import 'package:play_video/databse/database_model.dart';

import 'home_page.dart';

late File file;
late CameraController _cameraController;
late MaterialPageRoute<void> route;
late Future<void> initializeControllerFuture;
bool isfrontCamSelected = false;
late List<CameraDescription> cameras;
int countClick = 0;

class RecordingVideo extends StatefulWidget {
  const RecordingVideo({super.key});

  @override
  State<RecordingVideo> createState() => _RecordingVideoState();
}

class _RecordingVideoState extends State<RecordingVideo> {
  _initCamera() async {
    cameras = await availableCameras();
    final backcam = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(backcam, ResolutionPreset.high);
    await _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    initializeControllerFuture = _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: CameraPreview(_cameraController)),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: !_cameraController.value.isRecordingVideo
                          ? RawMaterialButton(
                              onPressed: () async {
                                try {
                                  await initializeControllerFuture;
                                  path = join(
                                      (await getApplicationDocumentsDirectory())
                                          .path,
                                      '${DateTime.now()}.mp4');
                                  setState(() {
                                    _startVideoRecording();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              padding: const EdgeInsets.all(10),
                              shape: CircleBorder(
                                  side: BorderSide(
                                      width: 3,
                                      color: Colors.white.withOpacity(0.8))),
                              child: Icon(
                                Icons.camera,
                                size: 50,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            )
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _cameraController.value.isRecordingVideo
                          ? RawMaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  if (_cameraController.value.isRecordingVideo) {
                                    _stopVideoRecording();
                                  }
                                });
                              },
                              padding: const EdgeInsets.all(10),
                              shape: CircleBorder(
                                  side: BorderSide(
                                      width: 3,
                                      color: Colors.white.withOpacity(0.8))),
                              child: const Icon(
                                Icons.stop,
                                size: 50.0,
                                color: Colors.red,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              countClick++;
                              if ((countClick % 2) != 0) {
                                isfrontCamSelected = true;
                                log('$countClick  and $isfrontCamSelected');
                              } else if ((countClick % 2) == 0) {
                                isfrontCamSelected = false;
                                log('$countClick  aaaaaaaaaaand $isfrontCamSelected');
                              }
                               selectCam();
                            });
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 40.0,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        )),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator(color: Colors.transparent,);
            }
          }),
    );
  }

  Future<void> _startVideoRecording() async {
    try {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    try {
      final file = await _cameraController.stopVideoRecording();
      final createdAt = DateTime.now().toString();
      final videoModel = VideoModel(
        title: 'Video Title',
        description: 'Video Description',
        filePath: file.path,
        createdAt: createdAt,
      );
      await insertVideo(videoModel);
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  Future<void> selectCam() async {
    (isfrontCamSelected == true)
        ? {
            setState(() async {
              cameras = await availableCameras();
              final frontcam = cameras.firstWhere((camera) =>
                  camera.lensDirection == CameraLensDirection.front);
              _cameraController = CameraController(frontcam, ResolutionPreset.high);
              _cameraController.initialize();
            })
          }
        : {
          setState(() async {
              cameras = await availableCameras();
              final backcam = cameras.firstWhere((camera) =>
                  camera.lensDirection == CameraLensDirection.back);
              _cameraController = CameraController(backcam, ResolutionPreset.high);
              _cameraController.initialize();
            })
        };
  }
}
