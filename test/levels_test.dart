import 'package:flutter_test/flutter_test.dart';
import 'package:game_9d8a0a41_001/config/levels.dart';

void main() {
  group('Level Configuration Tests', () {
    test('should have exactly 10 levels', () {
      expect(LevelConfigs.totalLevels, 10);
    });

    test('should have 3 free levels', () {
      expect(LevelConfigs.freeLevels, 3);
    });

    test('levels 1-3 should be free', () {
      expect(LevelConfigs.isLevelFree(1), true);
      expect(LevelConfigs.isLevelFree(2), true);
      expect(LevelConfigs.isLevelFree(3), true);
    });

    test('levels 4-10 should be locked', () {
      for (var i = 4; i <= 10; i++) {
        expect(LevelConfigs.isLevelFree(i), false);
      }
    });

    test('difficulty should increase with level', () {
      for (var i = 1; i < LevelConfigs.totalLevels; i++) {
        final current = LevelConfigs.getLevel(i);
        final next = LevelConfigs.getLevel(i + 1);
        expect(next.difficulty, greaterThanOrEqualTo(current.difficulty));
      }
    });

    test('target score should increase with level', () {
      for (var i = 1; i < LevelConfigs.totalLevels; i++) {
        final current = LevelConfigs.getLevel(i);
        final next = LevelConfigs.getLevel(i + 1);
        expect(next.targetScore, greaterThanOrEqualTo(current.targetScore));
      }
    });

    test('all levels should have valid config', () {
      for (final level in LevelConfigs.levels) {
        expect(level.levelNumber, greaterThan(0));
        expect(level.name, isNotEmpty);
        expect(level.difficulty, greaterThanOrEqualTo(0));
        expect(level.difficulty, lessThanOrEqualTo(1));
        expect(level.targetScore, greaterThan(0));
        expect(level.obstacleCount, greaterThan(0));
        expect(level.collectibleCount, greaterThan(0));
      }
    });

    test('getLevel returns first level for invalid input', () {
      expect(LevelConfigs.getLevel(0).levelNumber, 1);
      expect(LevelConfigs.getLevel(-1).levelNumber, 1);
      expect(LevelConfigs.getLevel(100).levelNumber, 1);
    });
  });
}
