import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/round_timer_providers.dart';
import '../domain/round_timer_state.dart';
import 'widgets/control_buttons.dart';
import 'widgets/setting_row.dart';
import 'widgets/screen_header.dart';
import 'widgets/timer_ring.dart';

/// Boks raund timer ana ekranı (Riverpod ConsumerWidget).
class RoundTimerScreen extends ConsumerWidget {
  const RoundTimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roundTimerProvider);
    final notifier = ref.read(roundTimerProvider.notifier);
    final canEdit = !state.isRunning;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.4),
            radius: 1.1,
            colors: [
              (state.isRest ? AppTheme.restGreen : AppTheme.fightRed)
                  .withValues(alpha: state.isRunning ? 0.16 : 0.07),
              AppTheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ScreenHeader(state: state)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: TimerRing(state: state)),
                ),
              ),
              SliverToBoxAdapter(
                child: RoundDots(
                  total: state.settings.totalRounds,
                  current: state.currentRound,
                  finished: state.isFinished,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainActionButton(
                        isRunning: state.isRunning,
                        isFinished: state.isFinished,
                        isRest: state.isRest,
                        onTap: () => state.isRunning
                            ? notifier.pause()
                            : notifier.start(),
                      ),
                      const SizedBox(width: 12),
                      ResetButton(onTap: notifier.reset),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SettingsTitle(canEdit: canEdit)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SettingRow(
                        icon: Icons.format_list_numbered_rounded,
                        title: 'Raund Sayısı',
                        valueText: '${state.settings.totalRounds}',
                        enabled: canEdit,
                        presets: const [3, 5, 8, 12],
                        onPreset: notifier.setTotalRounds,
                        onDecrement: () => notifier.setTotalRounds(
                          state.settings.totalRounds - 1,
                        ),
                        onIncrement: () => notifier.setTotalRounds(
                          state.settings.totalRounds + 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingRow(
                        icon: Icons.timer_outlined,
                        title: 'Raund Süresi',
                        valueText: formatDuration(
                          state.settings.roundSeconds,
                        ),
                        enabled: canEdit,
                        presets: const [60, 120, 180, 300],
                        onPreset: notifier.setRoundSeconds,
                        onDecrement: () => notifier.setRoundSeconds(
                          state.settings.roundSeconds - 15,
                        ),
                        onIncrement: () => notifier.setRoundSeconds(
                          state.settings.roundSeconds + 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingRow(
                        icon: Icons.self_improvement_rounded,
                        title: 'Dinlenme Süresi',
                        valueText: formatDuration(
                          state.settings.restSeconds,
                        ),
                        enabled: canEdit,
                        presets: const [30, 60, 90, 120],
                        onPreset: notifier.setRestSeconds,
                        onDecrement: () => notifier.setRestSeconds(
                          state.settings.restSeconds - 5,
                        ),
                        onIncrement: () => notifier.setRestSeconds(
                          state.settings.restSeconds + 5,
                        ),
                        accent: AppTheme.restGreen,
                      ),
                      const SizedBox(height: 12),
                      const SoundInfoCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
