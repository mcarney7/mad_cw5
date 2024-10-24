import 'dart:math';
import 'dart:ui'; // For Offset

class Fish {
  String name;
  double speed; // Speed ranges from 1 to 5
  Offset position;
  double size;
  Offset direction;
  String imagePath;

  Fish({
    required this.name,
    required this.speed,
    required this.position,
    required this.imagePath,
    this.size = 40.0,
  }) : direction = _getRandomDirection();

  // Generate a random initial direction
  static Offset _getRandomDirection() {
    final random = Random();
    double dx = random.nextDouble() * 2 - 1;
    double dy = random.nextDouble() * 2 - 1;
    return Offset(dx, dy).normalize(); // Normalize to maintain consistent direction
  }

  // Move fish realistically with speed adjustments
  void moveFish(Size containerSize) {
    double speedMultiplier;

    // Adjust speed for all settings (1 to 5) for all fish
    if (speed == 1) {
      speedMultiplier = 1.0; // Set speed for speed 1
    } else if (speed == 2) {
      speedMultiplier = 1.4; // Increase speed for speed 2
    } else if (speed == 3) {
      speedMultiplier = 2.1; // Increase speed for speed 3
    } else if (speed == 4) {
      speedMultiplier = 2.8; // Increase speed for speed 4
    } else if (speed == 5) {
      speedMultiplier = 3.5; // Increase speed for speed 5
    } else {
      speedMultiplier = speed * 0.7; // Default scaling
    }

    position = Offset(
      position.dx + direction.dx * speedMultiplier,
      position.dy + direction.dy * speedMultiplier,
    );

    // Check if fish hits the boundaries and change direction
    if (position.dx <= 0 || position.dx >= containerSize.width - size) {
      direction = Offset(-direction.dx, direction.dy);
    }
    if (position.dy <= 0 || position.dy >= containerSize.height - size) {
      direction = Offset(direction.dx, -direction.dy);
    }
  }
}

// Extension to normalize direction vectors
extension NormalizeOffset on Offset {
  Offset normalize() {
    double length = sqrt(dx * dx + dy * dy);
    return length > 0 ? this / length : this;
  }
}
