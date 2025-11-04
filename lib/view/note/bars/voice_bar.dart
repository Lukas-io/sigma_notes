import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';
import '../../../core/colors.dart';
import '../../../core/assets.dart';
import '../../../services/providers/auth_provider.dart';
import '../../../services/providers/recorder_provider.dart';
import '../../widgets/svg_button.dart';
import '../../widgets/voice_waveform.dart';

/// A voice recording bar with animated waveform
/// Fully integrated with Recorder Riverpod provider.
class VoiceBar extends ConsumerWidget {
  final int order;

  const VoiceBar({super.key, this.order = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorder = ref.watch(recorderProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          VoiceWaveform(amplitudes: recorder.amplitude, waveHeight: 60),
          Row(
            children: [
              // Timer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    _formatDuration(recorder.duration),
                    style: const TextStyle(
                      color: SigmaColors.gray,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        // Combine scale and fade for smooth morph transitions
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                  child: (() {
                    // 🔹 1. No file path? return empty box (animated)
                    if (recorder.filePath == null) {
                      return const SizedBox(
                        key: ValueKey('empty'),
                        width: 0,
                        height: 0,
                      );
                    }

                    return RecorderCenterButton(
                      state: recorder.state,
                      filePath: recorder.filePath,
                      onStart: () async {
                        await ref
                            .read(recorderProvider.notifier)
                            .startRecording(
                              userId:
                                  ref.read(authProvider).value?.id ??
                                  "currentUser",
                            );
                      },
                      onStop: () async {
                        await ref
                            .read(recorderProvider.notifier)
                            .stopRecording();
                      },
                      onCancel: () async {
                        await ref
                            .read(recorderProvider.notifier)
                            .cancelRecording();
                      },
                    );
                  })(),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: RecorderRightButton(
                    state: recorder.state,
                    filePath: recorder.filePath,
                    onStart: () async {
                      await ref
                          .read(recorderProvider.notifier)
                          .startRecording(
                            userId:
                                ref.read(authProvider).value?.id ??
                                "currentUser",
                          );
                    },
                    onStop: () async {
                      await ref.read(recorderProvider.notifier).stopRecording();
                    },
                    onCancel: () async {
                      await ref
                          .read(recorderProvider.notifier)
                          .cancelRecording();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}

class RecorderCenterButton extends ConsumerWidget {
  final RecordState state;
  final String? filePath;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const RecorderCenterButton({
    super.key,
    required this.state,
    required this.filePath,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔹 2. Currently recording => show STOP button
    if (state == RecordState.record) {
      return SvgButton(
        key: const ValueKey('stop'),
        iconSize: 28,
        assetPath: SigmaAssets.stopSvg,
        filled: false,
        onTap: onStop,
      );
    }

    // 🔹 3. Paused or stopped with a file => show DELETE button
    if (state == RecordState.pause || state == RecordState.stop) {
      return SvgButton(
        key: const ValueKey('delete'),
        assetPath: SigmaAssets.recordingDeleteSvg,
        filled: false,
        iconSize: 28,
        iconColor: CupertinoColors.destructiveRed,
        onTap: onCancel,
      );
    }

    // 🔹 4. Otherwise (default) => show START button
    return SigmaInkwell(
      key: const ValueKey('start'),
      onTap: onStart,
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: CupertinoColors.destructiveRed.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: const CircleAvatar(
          backgroundColor: CupertinoColors.destructiveRed,
          radius: 12,
        ),
      ),
    );
  }
}

class RecorderRightButton extends ConsumerWidget {
  final RecordState state;
  final String? filePath;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const RecorderRightButton({
    super.key,
    required this.state,
    required this.filePath,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Smooth fade + scale transition
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      child: (() {
        // Show stop button while recording
        if (state == RecordState.record) {
          return SvgButton(
            key: const ValueKey('stop'),
            iconSize: 28,
            assetPath: SigmaAssets.stopSvg,
            filled: false,
            onTap: onStop,
          );
        }

        // Show delete button when recording is stopped and file exists
        if (state == RecordState.stop && filePath != null) {
          return SvgButton(
            key: const ValueKey('delete'),
            assetPath: SigmaAssets.recordingDeleteSvg,
            filled: false,
            iconSize: 28,
            iconColor: CupertinoColors.destructiveRed,
            onTap: onCancel,
          );
        }

        // Default (start recording) button
        return SigmaInkwell(
          key: const ValueKey('start'),
          onTap: onStart,
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CupertinoColors.destructiveRed.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: const CircleAvatar(
              backgroundColor: CupertinoColors.destructiveRed,
              radius: 12,
            ),
          ),
        );
      })(),
    );
  }
}
