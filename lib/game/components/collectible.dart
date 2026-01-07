import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// A collectible item in the puzzle game.
///
/// Handles collision detection, score value, optional animation, and sound effect
/// when the collectible is picked up.
class Collectible extends SpriteComponent with CollisionCallbacks {
  final double scoreValue;
  final AudioPlayer _audioPlayer;

  Collectible({
    required Vector2 position,
    required this.scoreValue,
    required Sprite sprite,
    required this.size,
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(position: position, size: size, sprite: sprite);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addEffect(RotateEffect.by(
      360 * 2,
      EffectController(
        duration: 2,
        infinite: true,
        curve: Curves.linear,
      ),
    ));
    addEffect(MoveEffect.by(
      Vector2(0, 10),
      EffectController(
        duration: 1,
        infinite: true,
        curve: Curves.easeInOut,
      ),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      _audioPlayer.play('collect_sound.mp3');
      other.score += scoreValue;
      removeFromParent();
    }
  }
}