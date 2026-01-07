/// Performance configuration
/// 
/// Controls game performance settings for different device capabilities.

class PerformanceConfig {
  PerformanceConfig._();

  /// Target frame rate
  static const int targetFps = 60;

  /// Maximum number of particles
  static const int maxParticles = 100;

  /// Maximum active obstacles
  static const int maxObstacles = 50;

  /// Maximum active collectibles
  static const int maxCollectibles = 30;

  /// Enable object pooling
  static const bool useObjectPooling = true;

  /// Pool sizes
  static const int obstaclePoolSize = 30;
  static const int collectiblePoolSize = 20;
  static const int particlePoolSize = 50;

  /// Sprite batch rendering
  static const bool useSpriteBatch = true;

  /// Texture atlas usage
  static const bool useTextureAtlas = true;

  /// Collision detection optimization
  static const bool useQuadTree = true;

  /// Audio optimization
  static const int maxConcurrentSounds = 5;

  /// Memory limits
  static const int maxImageCacheSize = 100 * 1024 * 1024; // 100MB
}
