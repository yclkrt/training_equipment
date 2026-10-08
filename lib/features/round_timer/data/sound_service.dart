import 'package:audioplayers/audioplayers.dart';

/// Boks zili seslerini çalan ince servis katmanı.
///
/// - Raund **başlarken** → `boxing_bell_short.mp3` (kısa zil)
/// - Raund **bitip dinlenme başlarken** → `boxing_bell_long.mp3` (uzun zil)
class SoundService {
  SoundService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  static const String _shortBell = 'sounds/boxing_bell_short.mp3';
  static const String _longBell = 'sounds/boxing_bell_long.mp3';

  /// Raund başlangıç zili (kısa).
  Future<void> playRoundStart() async {
    await _play(_shortBell);
  }

  /// Dinlenme başlangıcı / raund bitiş zili (uzun).
  Future<void> playRestStart() async {
    await _play(_longBell);
  }

  /// Antrenman tamamen bittiğinde çalan zil (uzun).
  Future<void> playFinished() async {
    await _play(_longBell);
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Ses çalamazsa timer'ı asla bozma — sessizce geç.
    }
  }

  void dispose() => _player.dispose();
}
