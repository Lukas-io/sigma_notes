import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/colors.dart';
import '../../../core/assets.dart';
import '../../../models/content/audio.dart';
import '../../../services/providers/recorder_provider.dart';
import '../../widgets/svg_button.dart';

/// A voice recording bar with animated waveform
/// Fully integrated with Recorder Riverpod provider.
class VoiceBar extends ConsumerStatefulWidget {
  final Function(AudioContent)? onSave;
  final int order;

  const VoiceBar({super.key, this.onSave, this.order = 0});

  @override
  ConsumerState<VoiceBar> createState() => _VoiceBarState();
}

class _VoiceBarState extends ConsumerState<VoiceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  static const int barCount = 20;
  static const double maxBarHeight = 40;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<double> _generateWaveform(double amplitude) {
    final random = Random();
    return List.generate(barCount, (i) {
      final base = amplitude / 100;
      final fluctuation = random.nextDouble() * 0.3;
      return (base + fluctuation).clamp(0.0, 1.0) * maxBarHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recorderStateAsync = ref.watch(recorderProvider);

    return recorderStateAsync.when(
      data: (recorderState) {
        final waveform = _generateWaveform(recorderState.amplitude);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Waveform visualization
              SizedBox(
                height: maxBarHeight,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: waveform
                          .map(
                            (h) => Container(
                              width: 4,
                              height: h,
                              decoration: BoxDecoration(
                                color: SigmaColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Timer & buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer
                  Text(
                    _formatDuration(recorderState.duration),
                    style: const TextStyle(
                      color: SigmaColors.gray,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      // Record / Stop button
                      SvgButton(
                        assetPath: recorderState.isRecording
                            ? SigmaAssets.circleSvg
                            : SigmaAssets.microphoneSvg,
                        size: 40,
                        onTap: () async {
                          if (recorderState.isRecording) {
                            await ref
                                .read(recorderProvider.notifier)
                                .stopRecording();
                          } else {
                            await ref
                                .read(recorderProvider.notifier)
                                .startRecording(
                                  'recordings/${DateTime.now().millisecondsSinceEpoch}.m4a',
                                );
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      // Save button (only visible if recording stopped and file exists)
                      if (!recorderState.isRecording &&
                          recorderState.filePath != null)
                        SvgButton(
                          assetPath: SigmaAssets.checkMarkSvg,
                          size: 32,
                          onTap: () {
                            final audioContent = ref
                                .read(recorderProvider.notifier)
                                .toAudioContent(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  order: widget.order,
                                );
                            if (audioContent != null && widget.onSave != null) {
                              widget.onSave!(audioContent);
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
