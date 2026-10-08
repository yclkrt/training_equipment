import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/round_timer_state.dart';

/// Ortadaki büyük animasyonlu ilerleme halkası ve süre göstergesi.
class TimerRing extends StatelessWidget {
  const TimerRing({super.key, required this.state});

  final RoundTimerState state;

  @override
  Widget build(BuildContext context) {
    final isRest = state.isRest;
    final accent = state.isFinished
        ? AppTheme.gold
        : isRest
        ? AppTheme.restGreen
        : AppTheme.fightRed;

    final phaseText = switch (state.phase) {
      TimerPhase.idle => 'HAZIR',
      TimerPhase.round => 'RAUND ${state.currentRound}',
      TimerPhase.rest => 'DİNLENME',
      TimerPhase.finished => 'ANTRENMAN BİTTİ',
    };

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dış parlama.
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: state.isRunning ? 0.35 : 0.12),
                  blurRadius: 60,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          // Arka plan halkası.
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 14,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          // İlerleme halkası.
          SizedBox(
            width: 260,
            height: 260,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: state.progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) => CircularProgressIndicator(
                value: state.isIdle || state.isFinished ? 1 : (1 - value),
                strokeWidth: 14,
                strokeCap: StrokeCap.round,
                color: accent,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          // İç kart.
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surface,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    phaseText,
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatDuration(state.remainingSeconds),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Raund ${state.currentRound} / ${state.settings.totalRounds}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
