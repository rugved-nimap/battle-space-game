import 'package:flutter/material.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:get/get.dart';

/// Switches for the game controls (auto-fire, drag anywhere, vibration),
/// and optionally music and sound effects.
/// Used in the Settings dialog and in the pause menu.
class ControlSettings extends StatefulWidget {
  const ControlSettings({
    super.key,
    this.textColor = Colors.black87,
    this.showSound = false,
  });

  final Color textColor;

  /// Also show Music and SFX switches (the Settings dialog already has its own).
  final bool showSound;

  @override
  State<ControlSettings> createState() => _ControlSettingsState();
}

class _ControlSettingsState extends State<ControlSettings> {
  final controller = Get.find<GlobalController>();

  Widget _switch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: TextStyle(color: widget.textColor, fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: widget.textColor.withValues(alpha: 0.7), fontSize: 12),
      ),
      value: value,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSound) ...[
          _switch("Music", "Background music", controller.isBgOn, (_) => controller.toggleMusic()),
          _switch("Sound effects", "Shooting and explosions", controller.isSfxOn, (_) => controller.toggleSfx()),
        ],
        _switch("Auto-fire", "Shoot without dragging", controller.autoFire, controller.setAutoFire),
        _switch("Drag anywhere", "Move the ship by dragging anywhere on screen", controller.dragAnywhere, controller.setDragAnywhere),
        _switch("Vibration", "Buzz when you get hit or destroy enemies", controller.vibrationOn, controller.setVibration),
      ],
    );
  }
}
