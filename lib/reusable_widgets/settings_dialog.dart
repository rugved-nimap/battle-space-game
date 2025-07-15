import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.onBgPressed,
    required this.onSfxPressed,
    required this.isBgOn,
    required this.isSfxOn,
  });

  final Function()? onBgPressed;
  final Function()? onSfxPressed;
  final bool isBgOn, isSfxOn;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 25,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: widget.onBgPressed,
                  icon: Icon(
                    widget.isBgOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    color: Colors.indigoAccent,
                    size: 30,
                  ),
                ),
                const Text("Music", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: widget.onSfxPressed,
                  icon: Icon(
                    widget.isSfxOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    color: Colors.indigoAccent,
                    size: 30,
                  ),
                ),
                const Text("SFX", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: Get.back,
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            backgroundColor: const WidgetStatePropertyAll(Colors.black),
          ),
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        )
      ],
    );
  }
}
