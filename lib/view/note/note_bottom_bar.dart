import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sprung/sprung.dart';
import 'dart:ui';

enum NoteBarType { standard, text, draw, layout, details, minimal }

class NoteBottomBar extends StatelessWidget {
  final NoteBarType type;

  const NoteBottomBar({super.key, this.type = NoteBarType.minimal});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: SigmaColors.card),
            color: SigmaColors.white.withOpacity(0.75),
          ),
          child: AnimatedSize(
            duration: 800.ms,
            curve: Sprung(28),
            clipBehavior: Clip.none,
            child: AnimatedSwitcher(
              duration: 600.ms,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              child: Builder(
                key: ValueKey(type),
                builder: (_) {
                  switch (type) {
                    case NoteBarType.standard:
                      return _StandardBar();
                    case NoteBarType.text:
                      return _TextBar();
                    case NoteBarType.draw:
                      return _DrawBar();
                    case NoteBarType.layout:
                      return _LayoutBar();
                    case NoteBarType.details:
                      return _DetailsBar();
                    case NoteBarType.minimal:
                      return _MinimalBar();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Bar Widgets -------------------

class _StandardBar extends StatelessWidget {
  const _StandardBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i) => "Standard Item $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _TextBar extends StatelessWidget {
  const _TextBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => "Text Item $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _DrawBar extends StatelessWidget {
  const _DrawBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => "Draw Tool $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _LayoutBar extends StatelessWidget {
  const _LayoutBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(5, (i) => "Layout Option $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _DetailsBar extends StatelessWidget {
  const _DetailsBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(7, (i) => "Detail $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _MinimalBar extends StatelessWidget {
  const _MinimalBar();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(4, (i) => "Minimal $i");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text(items[i])),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}
