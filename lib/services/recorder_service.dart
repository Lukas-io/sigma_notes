import 'dart:async';
import 'package:record/record.dart';

/// Service to manage audio recording
class RecorderService {
  final _recorder = AudioRecorder();
  Timer? _timer;

  /// Check for permission
  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Start recording to a file path
  Future<String?> startRecording(String path) async {
    if (!await hasPermission()) return null;

    await _recorder.start(RecordConfig(), path: path);

    return path;
  }

  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    _timer?.cancel();
    return await _recorder.stop();
  }

  /// Cancel recording
  Future<void> cancelRecording() async {
    _timer?.cancel();
    await _recorder.cancel();
  }

  /// Dispose resources
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
  }
}
