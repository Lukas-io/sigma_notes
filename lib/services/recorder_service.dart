import 'dart:async';
import 'package:record/record.dart';

/// Service to manage audio recording
class RecorderService {
  final _recorder = AudioRecorder();
  Timer? _timer;

  /// Current amplitude stream
  Stream<Amplitude> get amplitudeStream =>
      _recorder.onAmplitudeChanged(const Duration(milliseconds: 250));

  /// Current record state stream
  Stream<RecordState> get stateStream => _recorder.onStateChanged();

  /// Check for permission
  Future<bool> hasPermission() => _recorder.hasPermission();

  /// Start recording to a file path
  Future<String?> startRecording(String path) async {
    if (!await hasPermission()) return null;

    await _recorder.start(RecordConfig(), path: path);

    return path;
  }

  /// Pause recording (supported by record package)
  Future<void> pauseRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.pause();
    }
  }

  /// Resume recording after a pause
  Future<void> resumeRecording() async {
    // Only resume if currently paused
    if (await _recorder.isRecording() == false) {
      await _recorder.resume();
    }
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
