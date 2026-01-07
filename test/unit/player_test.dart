import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';

void main() {
  group('Player Tests', () {
    test('player position updates with velocity', () {
      final position = Vector2(100, 100);
      final velocity = Vector2(10, 0);
      const dt = 0.016; // ~60fps
      
      position.add(velocity * dt);
      
      expect(position.x, closeTo(100.16, 0.01));
    });

    test('player position clamped to screen bounds', () {
      double clampPosition(double pos, double min, double max) {
        return pos.clamp(min, max);
      }
      
      expect(clampPosition(-10, 0, 400), 0);
      expect(clampPosition(450, 0, 400), 400);
      expect(clampPosition(200, 0, 400), 200);
    });

    test('invulnerability prevents damage', () {
      bool isInvulnerable = true;
      int lives = 3;
      
      void takeDamage() {
        if (!isInvulnerable) {
          lives--;
        }
      }
      
      takeDamage();
      
      expect(lives, 3);
    });

    test('collision detection works', () {
      bool checkCollision(Vector2 pos1, Vector2 size1, Vector2 pos2, Vector2 size2) {
        return pos1.x < pos2.x + size2.x &&
               pos1.x + size1.x > pos2.x &&
               pos1.y < pos2.y + size2.y &&
               pos1.y + size1.y > pos2.y;
      }
      
      expect(
        checkCollision(
          Vector2(0, 0), Vector2(50, 50),
          Vector2(25, 25), Vector2(50, 50),
        ),
        true,
      );
      
      expect(
        checkCollision(
          Vector2(0, 0), Vector2(50, 50),
          Vector2(100, 100), Vector2(50, 50),
        ),
        false,
      );
    });
  });
}
