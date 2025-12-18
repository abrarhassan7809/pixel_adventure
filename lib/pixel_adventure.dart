import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks {

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player();
  late JoystickComponent joystick;
  late JumpButton jumpButton;

  // ##### change into true for show controls #####
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelName = ['Level-01', 'Level-02'];
  int currentLevelIndex = 0;
  Level? currentLevel;

  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    _loadLevel();

    if (showControls) {
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png")
        ),
      ),

      margin: EdgeInsets.only(left: 10, bottom: 32),
      priority: 100,
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    // Remove current level and camera
    if (currentLevel != null) {
      currentLevel!.removeFromParent();
    }
    if (cam.parent != null) {
      cam.removeFromParent();
    }

    // Reset player state for new level
    player.resetForNewLevel();

    // Load next level
    if (currentLevelIndex < levelName.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // If last level, go back to first
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Level world = Level(
      player: player,
      levelName: levelName[currentLevelIndex],
    );

    currentLevel = world;

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    // Add camera and world to game
    addAll([cam, world]);
  }
}