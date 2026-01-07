import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

/// Obstacle component that moves toward the player
/// 
/// Scrolls from right to left in endless runner style.
class Obstacle extends SpriteComponent with HasGameRef, CollisionCallbacks {
  /// Base move speed - increases with game level
  double get moveSpeed => 180.0 + (gameRef.currentLevel ?? 1) * 15;

  Obstacle({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Try to load sprite
    try {
      sprite = await gameRef.loadSprite('obstacle.png');
    } catch (e) {
      // Sprite not available, will use render fallback
    }
    
    // Add collision hitbox - slightly smaller for fair gameplay
    add(RectangleHitbox(
      size: Vector2(size.x * 0.8, size.y * 0.9),
      position: Vector2(size.x * 0.1, size.y * 0.05),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move obstacle toward the left (toward player in endless runner)
    position.x -= moveSpeed * dt;
    
    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // If sprite is loaded, use parent render
    if (sprite != null) {
      super.render(canvas);
      return;
    }
    
    // Fallback: draw colored rectangle
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.red,
    );
  }
}
