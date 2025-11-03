import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sigma_notes/services/providers/audio_provider.dart';
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
    print(recorder.amplitude);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          VoiceWaveform(amplitudes: recorder.amplitude, waveHeight: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Text(
                _formatDuration(recorder.duration),
                style: const TextStyle(color: SigmaColors.gray, fontSize: 14),
              ),
              SvgButton(
                assetPath: SigmaAssets.pauseSvg,
                filled: false,
                onTap: () async {
                  await ref.read(recorderProvider.notifier).pauseRecording();
                },
              ),
              SvgButton(
                assetPath: SigmaAssets.playSvg,
                filled: false,
                onTap: () async {
                  await ref
                      .read(audioPlayerProvider.notifier)
                      .play(ref.read(recorderProvider).filePath ?? "");
                },
              ),
              SvgButton(
                assetPath: SigmaAssets.stopSvg,
                filled: false,
                onTap: () async {
                  await ref.read(recorderProvider.notifier).stopRecording();
                },
              ),
              SvgButton(
                assetPath: SigmaAssets.recordingDeleteSvg,
                filled: false,
                iconColor: CupertinoColors.destructiveRed,
              ),
              SigmaInkwell(
                onTap: () async {
                  await ref
                      .read(recorderProvider.notifier)
                      .startRecording(
                        userId:
                            ref.read(authProvider).value?.id ?? "currentUser",
                      );
                },
                child: Container(
                  padding: EdgeInsetsGeometry.all(1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CupertinoColors.destructiveRed.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: CupertinoColors.destructiveRed,
                    radius: 14,
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
