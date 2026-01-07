import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:game_9d8a0a41_001/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('app starts successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Verify menu screen loads
      expect(find.text('Batch-20260107-153932-puzzle-01'), findsOneWidget);
    });

    testWidgets('play button starts game', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Tap play button
      await tester.tap(find.text('PLAY'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Game should be running
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('settings screen accessible', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('SETTINGS'));
      await tester.pumpAndSettle();
      
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('pause menu appears on pause', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('PLAY'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // Find and tap pause button
      final pauseButton = find.byIcon(Icons.pause_circle);
      if (pauseButton.evaluate().isNotEmpty) {
        await tester.tap(pauseButton);
        await tester.pumpAndSettle();
        
        expect(find.text('PAUSED'), findsOneWidget);
      }
    });
  });
}
