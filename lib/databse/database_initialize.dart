import 'dart:developer';

import 'package:path/path.dart';
import 'package:play_video/databse/database_model.dart';
import 'package:sqflite/sqflite.dart';

late Database videoDatabase;
bool _isDatabaseInitialized = false;
Future<void> initialiseDb() async {
  if (!_isDatabaseInitialized) {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'auction.db');

    log('opened...');
    videoDatabase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' CREATE TABLE IF NOT EXISTS videos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          filePath TEXT,
          createdAt TEXT) ''');
    });
    _isDatabaseInitialized = true;
  }
}

Future<void> insertVideo(VideoModel video) async {
  await initialiseDb();
  final db = videoDatabase;
  await db.insert('videos', video.toMap());
}

Future<List<VideoModel>> getAllVideos() async {
  await initialiseDb();
  final db = videoDatabase;
  final List<Map<String, dynamic>> maps = await db.query('videos');
  return List.generate(maps.length, (i) {
    return VideoModel(
      title: maps[i]['title'],
      description: maps[i]['description'],
      filePath: maps[i]['filePath'],
      createdAt: maps[i]['createdAt'],
    );
  });
}
