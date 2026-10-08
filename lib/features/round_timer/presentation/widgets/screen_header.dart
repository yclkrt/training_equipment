import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/round_timer_state.dart';

/// Üst başlık: logo + isim + durum rozeti.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.state});

  final RoundTimerState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.fightRed, AppTheme.fightRedDark],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.fightRed.withValues(alpha: 0.4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_mma_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BOXING TIMER',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                Text(
                  'Raund sistemi',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          StatusChip(state: state),
        ],
      ),
    );
  }
}

/// Canlı durum rozeti (HAZIR / DÖVÜŞ / MOLA / ...).
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.state});

  final RoundTimerState state;

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;
    if (state.isRunning) {
      text = state.isRest ? 'MOLA' : 'DÖVÜŞ';
      color = state.isRest ? AppTheme.restGreen : AppTheme.fightRed;
    } else if (state.isPaused) {
      text = 'DURAKLATILDI';
      color = AppTheme.gold;
    } else if (state.isFinished) {
      text = 'TAMAMLANDI';
      color = AppTheme.gold;
    } else {
      text = 'HAZIR';
      color = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ayarlar bölümü başlığı + kilit göstergesi.
class SettingsTitle extends StatelessWidget {
  const SettingsTitle({super.key, required this.canEdit});

  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        children: [
          const Text(
            'ANTRENMAN AYARLARI',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          if (!canEdit)
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, size: 12, color: AppTheme.gold),
                  SizedBox(width: 4),
                  Text(
                    'KİLİTLİ',
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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

/// Ses bilgilendirme kartı.
class SoundInfoCard extends StatelessWidget {
  const SoundInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.music_note_rounded, color: AppTheme.gold, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Raund başında kısa zil, mola başında uzun zil çalar.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
