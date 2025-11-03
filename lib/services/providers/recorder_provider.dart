import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../models/content/audio.dart';
import '../recorder_service.dart';

part 'recorder_provider.g.dart';

/// Riverpod provider for the RecorderService
/// This service handles all recording-related actions like start, stop, cancel, and amplitude tracking.
/// Keep alive since it's a lightweight singleton.
@Riverpod(keepAlive: true)
RecorderService recorderService(Ref ref) {
  return RecorderService();
}

/// Represents the state of an ongoing recording
class RecorderState {
  final bool isRecording;
  final RecordState state;
  final Duration duration;
  final String? filePath;
  final String? id;

  final List<double> amplitude;

  const RecorderState({
    this.isRecording = false,
    this.state = RecordState.stop,
    this.duration = Duration.zero,
    this.filePath,
    this.id,
    this.amplitude = const [],
  });

  /// Creates a new state by copying existing values and overriding with provided ones
  RecorderState copyWith({
    bool? isRecording,
    Duration? duration,
    RecordState? state,
    String? filePath,
    double? amp,
  }) {
    final newAmplitude = List<double>.from(amplitude);
    if (amp != null) newAmplitude.add(amp);
    return RecorderState(
      isRecording: isRecording ?? this.isRecording,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      state: state ?? this.state,
      amplitude: newAmplitude,
    );
  }

  /// Converts the recorded file into an AudioContent model
  AudioContent toAudioContent({
    required int order,
    String? createdBy,
    String? lastModifiedBy,
  }) {
    final file = filePath != null ? File(filePath!) : null;
    return AudioContent(
      id: id,
      order: order,
      url: filePath ?? '',
      duration: duration,
      fileSizeBytes: file?.lengthSync(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
    );
  }
}

/// Riverpod notifier for recording
/// Uses the [RecorderService] to manage the recording lifecycle.
@riverpod
class Recorder extends _$Recorder {
  Timer? _timer;

  /// Build initial idle state
  @override
  RecorderState build() {
    return const RecorderState();
  }

  RecorderService get _service => ref.read(recorderServiceProvider);

  /// Start recording to the specified file path
  /// Automatically updates the duration every second
  Future<void> startRecording({required String userId}) async {
    final recordingId = Uuid().v4();

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recordings/$userId/$recordingId.m4a';
    final filePath = await _service.startRecording(path);
    if (filePath == null) return;
    _timer?.cancel();
    state = RecorderState(
      isRecording: true,
      duration: Duration.zero,
      filePath: filePath,
      state: RecordState.record,
      id: recordingId,
    );
    _service.amplitudeStream.listen((amp) {
      // state.whenData((s) {
      state = state.copyWith(
        duration: state.duration + const Duration(milliseconds: 250),
        amp: normalizeAmplitude(amp.current),
      );
      // });
    });

    // _service.stateStream.listen((recordState) {
    //   // state.whenData((s) {
    //   state = state.copyWith(state: recordState);
    //   // });
    // });
  }

  double normalizeAmplitude(double db) {
    print(db);
    // Clamp values between -120 and 0
    final clamped = db.clamp(-120.0, 0.0);
    // Convert to 0.0 -> 1.0 range
    return (clamped + 120) / 120;
  }

  /// Stop the current recording
  Future<void> stopRecording() async {
    await _service.stopRecording();
    _timer?.cancel();
    // state.whenData(
    //   (s) =>
    state = state.copyWith(isRecording: false);
    // );
  }

  /// Pause the current recording
  Future<void> pauseRecording() async {
    await _service.pauseRecording(); // call service
    _timer?.cancel(); // stop the timer while paused
    state = state.copyWith(isRecording: false);
    // state.whenData(
    //   (s) => state = AsyncValue.data(
    //     s.copyWith(isRecording: false), // not recording while paused
    //   ),
    // );
  }

  /// Resume a paused recording
  Future<void> resumeRecording() async {
    await _service.resumeRecording(); // call service
    // restart the timer
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );

      // state.whenData(
      //   (s) => state = AsyncValue.data(
      //     s.copyWith(duration: s.duration + const Duration(seconds: 1)),
      //   ),
      // );
    });
    state = state.copyWith(isRecording: true);

    // state.whenData(
    //   (s) => state = AsyncValue.data(
    //     s.copyWith(isRecording: true), // mark as recording again
    //   ),
    // );
  }

  /// Cancel the recording and remove the file
  Future<void> cancelRecording() async {
    await _service.cancelRecording();
    _timer?.cancel();
    // state = const AsyncValue.data(RecorderState());
    state = RecorderState();
  }

  /// Convert current recording to an AudioContent model
  AudioContent? toAudioContent({
    required int order,
    String? createdBy,
    String? lastModifiedBy,
  }) {
    return state.toAudioContent(
      order: order,
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
    );
  }
}
