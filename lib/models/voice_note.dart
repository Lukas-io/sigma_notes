class VoiceNoteModel {
  final String id;
  final String? filePath; // optional file path
  final Duration duration;
  final String? title; // optional title

  VoiceNoteModel({
    required this.id,
    this.filePath,
    required this.duration,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'duration': duration.inSeconds,
      'title': title,
    };
  }

  factory VoiceNoteModel.fromMap(Map<String, dynamic> map) {
    return VoiceNoteModel(
      id: map['id'],
      filePath: map['filePath'],
      duration: Duration(seconds: map['duration']),
      title: map['title'],
    );
  }
}
