import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:training_equipment/main.dart';

void main() {
  testWidgets('Boxing timer açılış ekranı çiziliyor', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BoxingTimerApp()));

    expect(find.text('BOXING TIMER'), findsOneWidget);
    expect(find.text('BAŞLA'), findsOneWidget);
    expect(find.text('Raund Sayısı'), findsOneWidget);
    expect(find.text('Raund Süresi'), findsOneWidget);
    expect(find.text('Dinlenme Süresi'), findsOneWidget);
  });

  testWidgets('BAŞLA butonuna basınca timer çalışıyor', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BoxingTimerApp()));

    await tester.tap(find.text('BAŞLA'));
    await tester.pump();

    expect(find.text('DURAKLAT'), findsOneWidget);
    expect(find.text('DÖVÜŞ'), findsOneWidget);
  });
}
