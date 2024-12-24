import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:play_video/databse/database_initialize.dart';
import 'package:play_video/databse/database_model.dart';
import 'package:play_video/screens/play_video.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoListPage extends StatelessWidget {
  VideoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Videos'),
      ),
      body: FutureBuilder(
        future: getAllVideos(),
        builder: (context, AsyncSnapshot<List<VideoModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No recorded videos'),
            );
          } else {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  VideoModel video = snapshot.data!.reversed.toList()[index];

                  return FutureBuilder<Uint8List?>(
                      future: VideoThumbnail.thumbnailData(
                        video: video.filePath,
                        imageFormat: ImageFormat.JPEG,
                        quality: 30,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                      videoPath: video.filePath),
                                ),
                              );
                              log('Video Path: ${video.filePath}');
                            },
                            child: GridTile(
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.transparent,
                          );
                        }
                      });
                });
          }
        },
      ),
    );
  }
}
