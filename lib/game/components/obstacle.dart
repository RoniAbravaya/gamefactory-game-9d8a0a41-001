import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

/// An obstacle component in the puzzle game.
/// Represents an obstacle that the player must avoid.
class Obstacle extends PositionComponent with CollisionCallbacks {
  /// The speed at which the obstacle moves.
  final double _speed;

  /// The damage dealt to the player upon collision.
  final int _damage;

  /// The visual representation of the obstacle.
  final Sprite _sprite;

  /// Creates a new instance of the Obstacle component.
  ///
  /// [position]: The initial position of the obstacle.
  /// [size]: The size of the obstacle.
  /// [speed]: The speed at which the obstacle moves.
  /// [damage]: The damage dealt to the player upon collision.
  /// [sprite]: The sprite used to represent the obstacle.
  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required double speed,
    required int damage,
    required Sprite sprite,
  })  : _speed = speed,
        _damage = damage,
        _sprite = sprite,
        super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addShape(HitboxShape.rectangle(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the obstacle based on its speed
    position.x -= _speed * dt;

    // If the obstacle goes off-screen, reset its position to the right side
    if (position.x + width < 0) {
      position.x = game.size.x + width;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Deal damage to the player upon collision
    other.damage(_damage);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw the obstacle's sprite
    _sprite.render(canvas, position: position, size: size);
  }
}