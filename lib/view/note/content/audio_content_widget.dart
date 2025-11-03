import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/content/audio.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

class AudioContentWidget extends StatelessWidget {
  final AudioContent content;

  const AudioContentWidget(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SigmaColors.black,
        borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        spacing: 20,
        children: [
          // Play button
          SvgButton(
            assetPath: SigmaAssets.playSvg,
            iconSize: 16,
            shadows: [],
            size: 30,
          ),

          // Waveform - takes remaining space
          Expanded(
            child: VoiceWaveform(
              amplitudes: [0.2, 0.5, 0.8, 0.4, 0.7, 0.6, 0.3],
            ),
          ),

          // Duration text
          Text(
            _formatDuration(content.duration ?? Duration()),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: SigmaColors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class VoiceWaveform extends StatelessWidget {
  final List<double> amplitudes; // normalized 0-1
  final double waveHeight;
  final double spacing;

  const VoiceWaveform({
    super.key,
    required this.amplitudes,
    this.waveHeight = 30,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate how many waves fit
        final waveWidth = 2.0; // fixed width per wave
        final count = (constraints.maxWidth / (waveWidth + spacing)).floor();

        // Normalize amplitudes to the number of waves we can show
        List<double> normalized = [];
        for (int i = 0; i < count; i++) {
          normalized.add(amplitudes[i % amplitudes.length]);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: normalized
              .map(
                (a) => Container(
                  width: waveWidth,
                  height: a * waveHeight,
                  decoration: BoxDecoration(
                    color: SigmaColors.gray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
