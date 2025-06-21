import 'package:flutter/material.dart';

class SpriteButton extends StatelessWidget {
  const SpriteButton({
    super.key,
    this.onPressed,
    required this.image,
    this.isSelected = false,
    this.imageSize = 80,
  });

  final Function()? onPressed;
  final String image;
  final bool isSelected;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200),
        side: const BorderSide(color: Colors.white),
      ),
      color: isSelected ? Colors.teal.withValues(alpha: 0.3) : null,
      clipBehavior: Clip.hardEdge,
      visualDensity: VisualDensity.compact,
      splashColor: Colors.blueGrey.withValues(alpha: 0.3),
      highlightColor: Colors.blueGrey.withValues(alpha: 0.3),
      padding: EdgeInsets.zero,
      child: Image.asset(image, width: imageSize, height: imageSize, fit: BoxFit.contain),
    );
  }
}
