import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/content/audio.dart';
import '../audio_service.dart';

part 'audio_provider.g.dart';

/// Enum for audio playback state
enum AudioState { idle, playing, paused, stopped }

/// Represents the current state of the audio player
class AudioPlayerState {
  final AudioState state;
  final String? filePath;
  final Duration position;
  final Duration duration;

  const AudioPlayerState({
    this.state = AudioState.idle,
    this.filePath,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  AudioPlayerState copyWith({
    AudioState? state,
    String? filePath,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlayerState(
      state: state ?? this.state,
      filePath: filePath ?? this.filePath,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }

  /// Convert current playback file into AudioContent
  AudioContent? toAudioContent({
    required int order,
    String? createdBy,
    String? lastModifiedBy,
  }) {
    if (filePath == null) return null;
    final file = File(filePath!);
    return AudioContent(
      id: filePath.hashCode.toString(),
      order: order,
      url: filePath!,
      duration: duration,
      fileSizeBytes: file.existsSync() ? file.lengthSync() : null,
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
    );
  }
}

/// Provider for AudioService (singleton, keep alive)
@Riverpod(keepAlive: true)
AudioService audioService(Ref ref) => AudioService();

/// StateNotifier for audio playback
@riverpod
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  AudioService get _service => ref.read(audioServiceProvider);

  @override
  Future<AudioPlayerState> build() async {
    ref.onDispose(() {
      _positionSub?.cancel();
      _durationSub?.cancel();
      _service.dispose();
    });
    return const AudioPlayerState();
  }

  /// Play a file
  Future<void> play(String filePath) async {
    await _service.play(filePath);

    state = AsyncValue.data(
      state.value?.copyWith(state: AudioState.playing, filePath: filePath) ??
          AudioPlayerState(state: AudioState.playing, filePath: filePath),
    );

    // Listen to position updates
    _positionSub?.cancel();
    _positionSub = _service.positionStream.listen((pos) {
      state.whenData((s) {
        state = AsyncValue.data(s.copyWith(position: pos));
      });
    });

    // Listen to duration updates
    _durationSub?.cancel();
    _durationSub = _service.durationStream.listen((dur) {
      state.whenData((s) {
        state = AsyncValue.data(s.copyWith(duration: dur ?? Duration.zero));
      });
    });
  }

  /// Pause playback
  Future<void> pause() async {
    await _service.pause();
    state.whenData((s) {
      state = AsyncValue.data(s.copyWith(state: AudioState.paused));
    });
  }

  /// Stop playback
  Future<void> stop() async {
    await _service.stop();
    state.whenData((s) {
      state = AsyncValue.data(
        s.copyWith(state: AudioState.stopped, position: Duration.zero),
      );
    });
  }

  /// Convert current playback to AudioContent
  AudioContent? toAudioContent({required int order}) {
    return state.value?.toAudioContent(order: order);
  }
}
