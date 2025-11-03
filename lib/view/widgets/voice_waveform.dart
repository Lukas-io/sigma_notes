import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

import '../../core/colors.dart';

class VoiceWaveform extends StatelessWidget {
  final List<double> amplitudes;
  final double waveHeight;
  final double spacing;
  final bool normalise;

  const VoiceWaveform({
    super.key,
    required this.amplitudes,
    this.waveHeight = 30,
    this.spacing = 4,
    this.normalise = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // How many waves fit
        final waveWidth = 2.0;
        final count = (constraints.maxWidth / (waveWidth + spacing)).floor();
        List<double> lastAmplitudes = [];

        // Take the last 'count' amplitudes
        final reversedAmps = amplitudes.reversed
            .take(count)
            .toList()
            .reversed
            .toList();

        // Pad with 0.0 at the start if there aren’t enough values
        final padding = List<double>.filled(count - reversedAmps.length, 0.0);

        lastAmplitudes = [...padding, ...reversedAmps];
        return SizedBox(
          height: waveHeight + 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: lastAmplitudes
                .map(
                  (amp) => AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Sprung(24),
                    width: waveWidth,
                    height: amp * waveHeight + 4,
                    decoration: BoxDecoration(
                      color: SigmaColors.gray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
