import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Ortadaki büyük başlat / duraklat butonu.
class MainActionButton extends StatelessWidget {
  const MainActionButton({
    super.key,
    required this.isRunning,
    required this.isFinished,
    required this.isRest,
    required this.onTap,
  });

  final bool isRunning;
  final bool isFinished;
  final bool isRest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isFinished
        ? AppTheme.gold
        : isRest
        ? AppTheme.restGreen
        : AppTheme.fightRed;

    final icon = isFinished
        ? Icons.replay_rounded
        : isRunning
        ? Icons.pause_rounded
        : Icons.play_arrow_rounded;

    final label = isFinished
        ? 'TEKRAR BAŞLAT'
        : isRunning
        ? 'DURAKLAT'
        : 'BAŞLA';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 150,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sıfırlama butonu (hayalet stil).
class ResetButton extends StatelessWidget {
  const ResetButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              color: AppTheme.textSecondary,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'SIFIRLA',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Raund noktaları (hangi raunddayız görselleştirmesi).
class RoundDots extends StatelessWidget {
  const RoundDots({
    super.key,
    required this.total,
    required this.current,
    required this.finished,
  });

  final int total;
  final int current;
  final bool finished;

  @override
  Widget build(BuildContext context) {
    final showCount = total.clamp(1, 12);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(showCount, (i) {
        final idx = i + 1;
        final done = finished || idx < current;
        final active = !finished && idx == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: done
                ? AppTheme.restGreen
                : active
                ? AppTheme.fightRed
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppTheme.fightRed.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
