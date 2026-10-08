// Riverpod mimarisi: domain katmanı — timer'ın tüm durum modeli.
// UI bu dosyaya hiç dokunmaz; sadece provider üzerinden okur.

/// Timer'ın içinde bulunduğu faz.
enum TimerPhase {
  /// Henüz başlamadı / sıfırlandı.
  idle,

  /// Raund süresi işliyor (dövüş).
  round,

  /// Dinlenme molası işliyor.
  rest,

  /// Tüm raundlar bitti.
  finished,
}

/// Timer çalışıyor mu, duraklatıldı mı?
enum TimerStatus { idle, running, paused, finished }

/// Kullanıcının değiştirebildiği antrenman ayarları.
class TimerSettings {
  const TimerSettings({
    this.totalRounds = 3,
    this.roundSeconds = 180,
    this.restSeconds = 60,
  });

  final int totalRounds;
  final int roundSeconds;
  final int restSeconds;

  TimerSettings copyWith({int? totalRounds, int? roundSeconds, int? restSeconds}) {
    return TimerSettings(
      totalRounds: totalRounds ?? this.totalRounds,
      roundSeconds: roundSeconds ?? this.roundSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}

/// Ekrana çizilen tek gerçek kaynağı (single source of truth).
class RoundTimerState {
  const RoundTimerState({
    this.settings = const TimerSettings(),
    this.status = TimerStatus.idle,
    this.phase = TimerPhase.idle,
    this.currentRound = 1,
    this.remainingSeconds = 180,
  });

  final TimerSettings settings;
  final TimerStatus status;
  final TimerPhase phase;
  final int currentRound;
  final int remainingSeconds;

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isIdle => status == TimerStatus.idle;
  bool get isFinished => status == TimerStatus.finished;
  bool get isRest => phase == TimerPhase.rest;
  bool get isRound => phase == TimerPhase.round;

  /// O anki fazın toplam süresi (progress halkası için).
  int get phaseTotalSeconds {
    if (phase == TimerPhase.rest) return settings.restSeconds;
    return settings.roundSeconds;
  }

  /// 0.0 – 1.0 arası ilerleme (halka için).
  double get progress {
    final total = phaseTotalSeconds;
    if (total <= 0) return 0;
    final done = (total - remainingSeconds) / total;
    return done.clamp(0.0, 1.0);
  }

  RoundTimerState copyWith({
    TimerSettings? settings,
    TimerStatus? status,
    TimerPhase? phase,
    int? currentRound,
    int? remainingSeconds,
  }) {
    return RoundTimerState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      phase: phase ?? this.phase,
      currentRound: currentRound ?? this.currentRound,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

/// MM:SS formatlayıcı (örn. 03:00, 00:45).
String formatDuration(int totalSeconds) {
  final s = totalSeconds.clamp(0, 35999);
  final m = s ~/ 60;
  final sec = s % 60;
  return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}
