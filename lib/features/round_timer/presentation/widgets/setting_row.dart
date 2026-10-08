import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Ayar satırı: başlık + [-] değer [+] + hızlı seçim çipleri.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.valueText,
    required this.onDecrement,
    required this.onIncrement,
    required this.enabled,
    this.presets = const [],
    this.onPreset,
    this.accent,
  });

  final IconData icon;
  final String title;
  final String valueText;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool enabled;
  final List<int> presets;
  final ValueChanged<int>? onPreset;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final accentColor = accent ?? AppTheme.fightRed;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.remove,
                  onTap: enabled ? onDecrement : null,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 76),
                  alignment: Alignment.center,
                  child: Text(
                    valueText,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add,
                  onTap: enabled ? onIncrement : null,
                ),
              ],
            ),
            if (presets.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presets.map((p) {
                  return GestureDetector(
                    onTap: enabled ? () => onPreset?.call(p) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _presetLabel(p),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _presetLabel(int p) => title.contains('Raund Sayısı')
      ? '$p'
      : p >= 60
      ? '${p ~/ 60} dk'
      : '$p sn';
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, color: AppTheme.textPrimary, size: 18),
        ),
      ),
    );
  }
}
