import 'dart:math';

import 'package:flutter/material.dart';
import 'package:play_video/databse/database_initialize.dart';
import 'package:play_video/screens/record_video.dart';
import 'package:play_video/screens/videos_list.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String path = '';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RecordingVideo()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          fixedSize: const Size(100, 40),
                        ),
                        child: const Icon(Icons.camera_alt_rounded),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // get();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>  VideoListPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          fixedSize: const Size(100, 40),
                        ),
                        child: Row(
                          children: const [
                            Text('Play'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.play_arrow, size: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
  }
}

get() async {
  final c = await videoDatabase.rawDelete('delete from videos');
  log(c);
}
