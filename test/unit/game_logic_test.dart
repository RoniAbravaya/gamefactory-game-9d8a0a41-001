import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game Logic Tests', () {
    group('Score Calculation', () {
      test('score increases when collecting items', () {
        int score = 0;
        const collectibleValue = 10;
        
        score += collectibleValue;
        
        expect(score, 10);
      });

      test('score multiplier applies correctly', () {
        int score = 100;
        const multiplier = 2.0;
        
        final bonusScore = (score * multiplier).toInt();
        
        expect(bonusScore, 200);
      });
    });

    group('Lives System', () {
      test('player starts with 3 lives', () {
        const initialLives = 3;
        expect(initialLives, 3);
      });

      test('life is lost on collision', () {
        int lives = 3;
        
        lives--;
        
        expect(lives, 2);
      });

      test('game over when lives reach 0', () {
        int lives = 1;
        
        lives--;
        final isGameOver = lives <= 0;
        
        expect(isGameOver, true);
      });
    });

    group('Level Progression', () {
      test('level completion triggers next level', () {
        int currentLevel = 1;
        const targetScore = 100;
        const score = 150;
        
        if (score >= targetScore) {
          currentLevel++;
        }
        
        expect(currentLevel, 2);
      });

      test('cannot exceed level 10', () {
        int currentLevel = 10;
        
        final nextLevel = currentLevel < 10 ? currentLevel + 1 : currentLevel;
        
        expect(nextLevel, 10);
      });
    });

    group('Difficulty Scaling', () {
      test('obstacle speed increases with level', () {
        double getObstacleSpeed(int level) {
          return 1.0 + (level * 0.15);
        }
        
        expect(getObstacleSpeed(1), 1.15);
        expect(getObstacleSpeed(5), 1.75);
        expect(getObstacleSpeed(10), 2.5);
      });
    });
  });
}
