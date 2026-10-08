import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/round_timer/presentation/round_timer_screen.dart';

void main() {
  runApp(const ProviderScope(child: BoxingTimerApp()));
}

/// Riverpod mimarisi kökü: tüm uygulama ProviderScope altında.
class BoxingTimerApp extends StatelessWidget {
  const BoxingTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boxing Round Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const RoundTimerScreen(),
    );
  }
}
