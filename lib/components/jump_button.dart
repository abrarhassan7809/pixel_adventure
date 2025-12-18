import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  JumpButton();

  final double margin = 32;
  final double buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 100;
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    size = Vector2.all(buttonSize);

    // Initial position
    updatePosition();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePosition();
  }

  void updatePosition() {
    position = Vector2(
      game.size.x - margin - buttonSize + 20,
      game.size.y - margin - buttonSize,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    game.player.hasJumped = false;
    super.onTapCancel(event);
  }
}