import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sound_service.dart';
import '../domain/round_timer_state.dart';

/// Riverpod mimarisi — application katmanı.
///
/// Tüm timer mantığı burada. UI sadece [RoundTimerNotifier]'ı tetikler
/// ve state'i izler; asla kendi içinde sayaç tutmaz.
class RoundTimerNotifier extends Notifier<RoundTimerState> {
  Timer? _ticker;
  SoundService? _sound;

  SoundService get _sounds {
    _sound ??= SoundService();
    return _sound!;
  }

  @override
  RoundTimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _sound?.dispose();
    });
    return const RoundTimerState();
  }

  // ── Ayarlar (sadece timer çalışmıyorken) ──────────────────────────

  void setTotalRounds(int value) {
    if (state.isRunning) return;
    final v = value.clamp(1, 15);
    final settings = state.settings.copyWith(totalRounds: v);
    _applySettings(settings);
  }

  void setRoundSeconds(int value) {
    if (state.isRunning) return;
    final v = value.clamp(10, 600);
    final settings = state.settings.copyWith(roundSeconds: v);
    _applySettings(settings);
  }

  void setRestSeconds(int value) {
    if (state.isRunning) return;
    final v = value.clamp(5, 300);
    final settings = state.settings.copyWith(restSeconds: v);
    _applySettings(settings);
  }

  void _applySettings(TimerSettings settings) {
    // Timer hiç başlamadıysa / bittiyse kalan süreyi de tazele.
    final remaining = (state.isIdle || state.isFinished)
        ? settings.roundSeconds
        : state.remainingSeconds;
    final round = (state.isIdle || state.isFinished) ? 1 : state.currentRound;
    state = state.copyWith(
      settings: settings,
      currentRound: round,
      remainingSeconds: remaining,
    );
  }

  // ── Kontroller ───────────────────────────────────────────────────

  /// Başlat / Devam et.
  Future<void> start() async {
    if (state.isRunning) return;

    if (state.isFinished) {
      // Bitmiş antrenmanı yeniden başlat.
      state = RoundTimerState(
        settings: state.settings,
        status: TimerStatus.running,
        phase: TimerPhase.round,
        currentRound: 1,
        remainingSeconds: state.settings.roundSeconds,
      );
      await _sounds.playRoundStart();
      _startTicker();
      return;
    }

    if (state.isPaused) {
      state = state.copyWith(status: TimerStatus.running);
      _startTicker();
      return;
    }

    // idle → ilk raund.
    state = state.copyWith(
      status: TimerStatus.running,
      phase: TimerPhase.round,
      currentRound: 1,
      remainingSeconds: state.settings.roundSeconds,
    );
    await _sounds.playRoundStart();
    _startTicker();
  }

  void pause() {
    if (!state.isRunning) return;
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void reset() {
    _ticker?.cancel();
    state = RoundTimerState(settings: state.settings);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _tick() async {
    if (state.remainingSeconds > 1) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      return;
    }
    await _advancePhase();
  }

  /// Süre doldu → sonraki faza geç + doğru zili çal.
  Future<void> _advancePhase() async {
    final s = state;

    if (s.phase == TimerPhase.round) {
      if (s.currentRound >= s.settings.totalRounds) {
        // Antrenman bitti.
        _ticker?.cancel();
        state = s.copyWith(
          status: TimerStatus.finished,
          phase: TimerPhase.finished,
          remainingSeconds: 0,
        );
        await _sounds.playFinished();
      } else if (s.settings.restSeconds <= 0) {
        // Dinlenme yoksa direkt sonraki raunda geç.
        state = s.copyWith(
          currentRound: s.currentRound + 1,
          phase: TimerPhase.round,
          remainingSeconds: s.settings.roundSeconds,
        );
        await _sounds.playRoundStart();
      } else {
        // Raund bitti → dinlenme başlıyor → UZUN zil.
        state = s.copyWith(
          phase: TimerPhase.rest,
          remainingSeconds: s.settings.restSeconds,
        );
        await _sounds.playRestStart();
      }
    } else if (s.phase == TimerPhase.rest) {
      // Dinlenme bitti → yeni raund başlıyor → KISA zil.
      state = s.copyWith(
        currentRound: s.currentRound + 1,
        phase: TimerPhase.round,
        remainingSeconds: s.settings.roundSeconds,
      );
      await _sounds.playRoundStart();
    }
  }
}
