/// Game state enum for state machine
/// 
/// Represents the different states the game can be in.
enum GameState {
  /// Game is actively being played
  playing,
  
  /// Game is paused (overlay shown)
  paused,
  
  /// Game over - player lost all lives
  gameOver,
  
  /// Level completed successfully
  levelComplete,
  
  /// Main menu state
  menu,
}
