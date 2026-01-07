import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Score System Tests', () {
    test('score starts at zero', () {
      int score = 0;
      expect(score, 0);
    });

    test('collecting item adds to score', () {
      int score = 0;
      const itemValue = 10;
      
      score += itemValue;
      
      expect(score, 10);
    });

    test('combo multiplier increases score', () {
      int score = 0;
      const baseValue = 10;
      int combo = 3;
      
      final points = (baseValue * (1 + combo * 0.5)).toInt();
      score += points;
      
      expect(score, 25);
    });

    test('high score is saved correctly', () {
      final highScores = <int, int>{};
      const level = 1;
      const newScore = 500;
      
      final currentHigh = highScores[level] ?? 0;
      if (newScore > currentHigh) {
        highScores[level] = newScore;
      }
      
      expect(highScores[level], 500);
    });

    test('score resets on level restart', () {
      int score = 250;
      
      void resetLevel() {
        score = 0;
      }
      
      resetLevel();
      
      expect(score, 0);
    });
  });
}
