import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/painting.dart';

/// The Player component for the puzzle game.
class Player extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  /// The player's current health.
  double health = 100.0;

  /// The duration of invulnerability frames after taking damage.
  static const double invulnerabilityDuration = 1.0;

  /// The time remaining in the invulnerability frames.
  double _invulnerabilityTimeRemaining = 0.0;

  /// The player's movement speed.
  static const double moveSpeed = 200.0;

  /// The player's animation states.
  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation hurtAnimation;

  Player(Vector2 position) : super(position: position, size: Vector2.all(32.0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's animations
    idleAnimation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(32.0),
      ),
    );
    walkAnimation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32.0),
      ),
    );
    hurtAnimation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.2,
        textureSize: Vector2.all(32.0),
      ),
    );

    // Set the initial animation
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle movement
    final direction = Vector2.zero();
    if (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowLeft)) {
      direction.x -= 1;
    }
    if (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowRight)) {
      direction.x += 1;
    }
    if (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowUp)) {
      direction.y -= 1;
    }
    if (gameRef.keyboard.isPressed(LogicalKeyboardKey.arrowDown)) {
      direction.y += 1;
    }
    position += direction.normalized() * moveSpeed * dt;

    // Handle invulnerability frames
    if (_invulnerabilityTimeRemaining > 0) {
      _invulnerabilityTimeRemaining -= dt;
      if (_invulnerabilityTimeRemaining <= 0) {
        _invulnerabilityTimeRemaining = 0;
      }
    }

    // Update the animation based on the player's state
    if (direction.isZero()) {
      animation = idleAnimation;
    } else {
      animation = walkAnimation;
    }
    if (_invulnerabilityTimeRemaining > 0) {
      animation = hurtAnimation;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with obstacles and collectibles
    if (other is Obstacle) {
      // Handle collision with an obstacle
      takeDamage(10.0);
    } else if (other is Collectible) {
      // Handle collision with a collectible
      other.collect();
    }
  }

  /// Damages the player and starts the invulnerability frames.
  void takeDamage(double amount) {
    if (_invulnerabilityTimeRemaining <= 0) {
      health -= amount;
      _invulnerabilityTimeRemaining = invulnerabilityDuration;
    }
  }
}

/// An obstacle that the player can collide with.
class Obstacle extends PositionComponent with HasGameRef, CollisionCallbacks {
  Obstacle(Vector2 position, Vector2 size) : super(position: position, size: size);
}

/// A collectible that the player can pick up.
class Collectible extends PositionComponent with HasGameRef, CollisionCallbacks {
  Collectible(Vector2 position, Vector2 size) : super(position: position, size: size);

  void collect() {
    // Implement the logic for collecting the item
    removeFromParent();
  }
}