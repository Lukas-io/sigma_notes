import 'dart:async';
import 'dart:io';
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
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  // access the ref injected automatically
  /// Build initial idle state
  @override
  RecorderState build() {
    // Clean up any existing subscription when rebuilding
    _amplitudeSubscription?.cancel();

    // Capture the service reference before onDispose
    final service = ref.read(recorderServiceProvider);

    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _amplitudeSubscription?.cancel();
      service.dispose();
    });

    return const RecorderState();
  }

  RecorderService get _service => ref.read(recorderServiceProvider);

  /// Start recording to the specified file path
  /// Automatically updates the duration every second
  Future<void> startRecording({required String userId}) async {
    final recordingId = Uuid().v4();

    final path = 'recordings/$userId/$recordingId.m4a';
    final filePath = await _service.startRecording(path);
    if (filePath == null) return;
    state = RecorderState(
      isRecording: true,
      duration: Duration.zero,
      filePath: filePath,
      state: RecordState.record,
      id: recordingId,
    );

    // Cancel any existing subscription
    _amplitudeSubscription?.cancel();

    // Set up amplitude stream listener with proper disposal handling
    _amplitudeSubscription = _service.amplitudeStream.listen((amp) {
      // Check if the provider is still mounted before updating state
      if (!ref.mounted) return;
      state = state.copyWith(
        duration: state.duration + const Duration(milliseconds: 100),
        amp: normalizeAmplitude(amp.current),
      );
    });

    // _service.stateStream.listen((recordState) {
    //   state = state.copyWith(state: recordState);
    // });
  }

  double normalizeAmplitude(double db) {
    final clamped = db.clamp(-60.0, 0.0);
    // Convert to 0.0 -> 1.0 range
    return (clamped + 60) / 60;
  }

  /// Stop the current recording
  Future<void> stopRecording() async {
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;
    await _service.stopRecording();
    // Check if the provider is still mounted after async operation
    if (!ref.mounted) return;
    state = state.copyWith(isRecording: false);
  }

  /// Pause the current recording
  Future<void> pauseRecording() async {
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;
    await _service.pauseRecording();
    // Check if the provider is still mounted after async operation
    if (!ref.mounted) return;
    state = state.copyWith(isRecording: false);
  }

  /// Resume a paused recording
  Future<void> resumeRecording() async {
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;
    await _service.resumeRecording();
    // Check if the provider is still mounted after async operation
    if (!ref.mounted) return;
    state = state.copyWith(isRecording: true);
  }

  /// Cancel the recording and remove the file
  Future<void> cancelRecording() async {
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;
    await _service.cancelRecording();
    // Check if the provider is still mounted after async operation
    if (!ref.mounted) return;
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
