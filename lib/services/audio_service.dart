import 'dart:async';
import 'package:just_audio/just_audio.dart';

/// Enum representing playback state
enum AudioState { idle, playing, paused, stopped }

/// State of the audio player
class AudioPlayerState {
  final AudioState status;
  final Duration position;
  final Duration duration;
  final String? filePath;

  const AudioPlayerState({
    this.status = AudioState.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.filePath,
  });

  AudioPlayerState copyWith({
    AudioState? status,
    Duration? position,
    Duration? duration,
    String? filePath,
  }) {
    return AudioPlayerState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
    );
  }
}

/// Service for audio playback
class AudioService {
  final _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSub;

  /// Play an audio file
  Future<void> play(String filePath) async {
    await _player.setFilePath(filePath);
    await _player.play();
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _player.dispose();
    await _positionSub?.cancel();
  }

  /// Stream for current playback position
  Stream<Duration> get positionStream => _player.positionStream;

  /// Stream for total duration
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Current player state
  AudioState get state {
    switch (_player.playing) {
      case true:
        return AudioState.playing;
      case false:
        return AudioState.paused;
    }
  }
}
