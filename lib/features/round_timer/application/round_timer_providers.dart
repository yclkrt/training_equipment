import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/round_timer_state.dart';
import 'round_timer_notifier.dart';

/// Riverpod mimarisi — provider katmanı.
/// UI yalnızca bu provider'ları kullanır.

/// Timer'ın tamamını yöneten NotifierProvider.
final roundTimerProvider =
    NotifierProvider<RoundTimerNotifier, RoundTimerState>(
      RoundTimerNotifier.new,
    );

/// Türetilmiş (derived) provider örnekleri.
final remainingTextProvider = Provider<String>((ref) {
  final state = ref.watch(roundTimerProvider);
  return formatDuration(state.remainingSeconds);
});

final phaseLabelProvider = Provider<String>((ref) {
  final state = ref.watch(roundTimerProvider);
  switch (state.phase) {
    case TimerPhase.idle:
      return 'HAZIR';
    case TimerPhase.round:
      return 'RAUND ${state.currentRound}';
    case TimerPhase.rest:
      return 'DİNLENME';
    case TimerPhase.finished:
      return 'BİTTİ';
  }
});
