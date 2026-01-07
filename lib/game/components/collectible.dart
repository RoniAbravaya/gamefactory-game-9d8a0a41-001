import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// Collectible coin component with floating animation
/// 
/// Moves from right to left and bobs up and down.
class Collectible extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final int value;
  
  /// Base move speed - increases with level
  double get _moveSpeed => 180.0 + (gameRef.currentLevel ?? 1) * 10;
  
  /// Floating animation variables
  double _floatOffset = 0;
  final double _floatSpeed = 4.0;
  final double _floatAmplitude = 8.0;
  double _baseY = 0;
  
  /// Collection state
  bool _isCollected = false;

  Collectible({
    required Vector2 position,
    this.value = 10,
  }) : super(
          position: position,
          size: Vector2(32, 32),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Try to load sprite
    try {
      sprite = await gameRef.loadSprite('coin.png');
    } catch (e) {
      // Sprite not available, will use render fallback
    }
    
    // Store base Y position for floating animation
    _baseY = position.y;
    
    // Randomize starting offset for variety
    _floatOffset = Random().nextDouble() * pi * 2;
    
    // Add circular hitbox
    add(CircleHitbox(
      radius: size.x / 2 * 0.8,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Don't update if being collected
    if (_isCollected) return;
    
    // Move collectible toward the left
    position.x -= _moveSpeed * dt;
    
    // Floating animation (bob up and down)
    _floatOffset += _floatSpeed * dt;
    position.y = _baseY + sin(_floatOffset) * _floatAmplitude;
    
    // Gentle rotation for visual interest
    angle = sin(_floatOffset * 0.5) * 0.1;
    
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
    
    // Fallback: draw colored circle
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      Paint()..color = Colors.amber,
    );
  }

  /// Called when player collects this item
  void collect() {
    if (_isCollected) return;
    _isCollected = true;
    
    // Disable collision
    removeAll(children.whereType<ShapeHitbox>());
    
    // Collection animation - scale up and fade out
    add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2),
      ),
    );
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.2),
        onComplete: removeFromParent,
      ),
    );
    
    // Move up slightly
    add(
      MoveByEffect(
        Vector2(0, -30),
        EffectController(duration: 0.2),
      ),
    );
  }
}
