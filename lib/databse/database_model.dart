
class VideoModel {
  final String title;
  final String description;
  final String filePath;
  final String createdAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.filePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'filePath': filePath,
      'createdAt': createdAt,
    };
  }
}